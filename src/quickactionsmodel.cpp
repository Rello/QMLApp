#include "quickactionsmodel.h"

QuickActionsModel::QuickActionsModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int QuickActionsModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_items.size();
}

QVariant QuickActionsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size()) {
        return {};
    }

    const auto &item = m_items.at(index.row());
    switch (role) {
    case IdRole:
        return item.id;
    case LabelRole:
        return item.label;
    case IconNameRole:
        return item.iconName;
    default:
        return {};
    }
}

QHash<int, QByteArray> QuickActionsModel::roleNames() const
{
    return {
        { IdRole, "id" },
        { LabelRole, "label" },
        { IconNameRole, "iconName" },
    };
}

void QuickActionsModel::setItems(const QVector<QuickActionItem> &items)
{
    beginResetModel();
    m_items = items;
    endResetModel();
}

