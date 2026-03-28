#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct QuickActionItem {
    QString id;
    QString label;
    QString iconName;
};

class QuickActionsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        LabelRole,
        IconNameRole
    };
    Q_ENUM(Roles)

    explicit QuickActionsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setItems(const QVector<QuickActionItem> &items);

private:
    QVector<QuickActionItem> m_items;
};

