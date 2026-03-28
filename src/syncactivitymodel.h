#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct SyncItem {
    QString title;
    QString subtitle;
    QString iconName;
    QString state;
    QString completedText;
    double currentAmountMb = 0.0;
    double totalAmountMb = 0.0;
    double stepAmountMb = 0.0;
};

class SyncActivityModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        SubtitleRole,
        StatusTextRole,
        ProgressRole,
        IconNameRole,
        StateRole
    };
    Q_ENUM(Roles)

    explicit SyncActivityModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setItems(const QVector<SyncItem> &items);
    void advanceSimulation();
    bool archiveCompletedItem();

    int activeTransferCount() const;
    QString aggregateProgressText() const;

private:
    QString formatStatusText(const SyncItem &item) const;
    QString formatAmount(double amountMb) const;

    QVector<SyncItem> m_items;
};

