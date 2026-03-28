#include "syncactivitymodel.h"

#include <QtMath>

SyncActivityModel::SyncActivityModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int SyncActivityModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_items.size();
}

QVariant SyncActivityModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size()) {
        return {};
    }

    const auto &item = m_items.at(index.row());
    switch (role) {
    case TitleRole:
        return item.title;
    case SubtitleRole:
        return item.subtitle;
    case StatusTextRole:
        return formatStatusText(item);
    case ProgressRole:
        return item.totalAmountMb > 0.0 ? qBound(0.0, item.currentAmountMb / item.totalAmountMb, 1.0) : 0.0;
    case IconNameRole:
        return item.iconName;
    case StateRole:
        return item.state;
    default:
        return {};
    }
}

QHash<int, QByteArray> SyncActivityModel::roleNames() const
{
    return {
        { TitleRole, "title" },
        { SubtitleRole, "subtitle" },
        { StatusTextRole, "statusText" },
        { ProgressRole, "progress" },
        { IconNameRole, "iconName" },
        { StateRole, "state" },
    };
}

void SyncActivityModel::setItems(const QVector<SyncItem> &items)
{
    beginResetModel();
    m_items = items;
    endResetModel();
}

void SyncActivityModel::advanceSimulation()
{
    for (int row = 0; row < m_items.size(); ++row) {
        auto &item = m_items[row];
        if (item.state != QStringLiteral("syncing")) {
            continue;
        }

        item.currentAmountMb = qMin(item.totalAmountMb, item.currentAmountMb + item.stepAmountMb);
        if (item.currentAmountMb >= item.totalAmountMb) {
            item.currentAmountMb = item.totalAmountMb;
            item.state = QStringLiteral("complete");
            item.completedText = QStringLiteral("Uploaded just now");
        }

        const QModelIndex changedIndex = index(row, 0);
        emit dataChanged(changedIndex, changedIndex, {
            StatusTextRole,
            ProgressRole,
            StateRole,
        });
    }
}

bool SyncActivityModel::archiveCompletedItem()
{
    for (int row = 0; row < m_items.size(); ++row) {
        if (m_items.at(row).state != QStringLiteral("complete")) {
            continue;
        }

        beginRemoveRows(QModelIndex(), row, row);
        m_items.removeAt(row);
        endRemoveRows();
        return true;
    }

    return false;
}

int SyncActivityModel::activeTransferCount() const
{
    int count = 0;
    for (const auto &item : m_items) {
        if (item.state == QStringLiteral("syncing")) {
            ++count;
        }
    }
    return count;
}

QString SyncActivityModel::aggregateProgressText() const
{
    double currentAmount = 0.0;
    double totalAmount = 0.0;
    for (const auto &item : m_items) {
        if (item.state != QStringLiteral("syncing")) {
            continue;
        }

        currentAmount += item.currentAmountMb;
        totalAmount += item.totalAmountMb;
    }

    if (totalAmount <= 0.0) {
        return QStringLiteral("Everything is ready.");
    }

    return QStringLiteral("%1 of %2")
        .arg(formatAmount(currentAmount), formatAmount(totalAmount));
}

QString SyncActivityModel::formatStatusText(const SyncItem &item) const
{
    if (item.state == QStringLiteral("complete")) {
        return item.completedText;
    }

    return QStringLiteral("Uploading %1 of %2")
        .arg(formatAmount(item.currentAmountMb), formatAmount(item.totalAmountMb));
}

QString SyncActivityModel::formatAmount(double amountMb) const
{
    if (amountMb < 1.0) {
        return QStringLiteral("%1 KB").arg(qRound(amountMb * 1024.0));
    }

    const bool wholeNumber = qFuzzyCompare(amountMb + 1.0, qFloor(amountMb) + 1.0);
    return wholeNumber
        ? QStringLiteral("%1 MB").arg(qRound(amountMb))
        : QStringLiteral("%1 MB").arg(QString::number(amountMb, 'f', 1));
}

