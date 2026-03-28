#pragma once

#include <QObject>
#include <QPointer>
#include <QRect>
#include <QString>
#include <QTimer>

#include "quickactionsmodel.h"
#include "syncactivitymodel.h"

class QQuickWindow;
class QSystemTrayIcon;

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPage READ currentPage NOTIFY currentPageChanged)
    Q_PROPERTY(bool popupVisible READ popupVisible NOTIFY popupVisibleChanged)
    Q_PROPERTY(QString accountName READ accountName NOTIFY accountNameChanged)
    Q_PROPERTY(QString statusTitle READ statusTitle NOTIFY statusTitleChanged)
    Q_PROPERTY(QString statusSubtitle READ statusSubtitle NOTIFY statusSubtitleChanged)
    Q_PROPERTY(int syncingCount READ syncingCount NOTIFY syncingCountChanged)
    Q_PROPERTY(QObject *syncActivityModel READ syncActivityModel CONSTANT)
    Q_PROPERTY(QObject *quickActionsModel READ quickActionsModel CONSTANT)

public:
    explicit AppController(QObject *parent = nullptr);

    QString currentPage() const;
    bool popupVisible() const;
    QString accountName() const;
    QString statusTitle() const;
    QString statusSubtitle() const;
    int syncingCount() const;
    QObject *syncActivityModel();
    QObject *quickActionsModel();

    Q_INVOKABLE void togglePopup();
    Q_INVOKABLE void showPopup();
    Q_INVOKABLE void hidePopup();
    Q_INVOKABLE void showHome();
    Q_INVOKABLE void showActivity();
    Q_INVOKABLE void triggerAction(const QString &id);
    Q_INVOKABLE void advanceScenario();
    Q_INVOKABLE void registerPopup(QObject *windowObject);

    void setTrayIcon(QSystemTrayIcon *trayIcon);

signals:
    void currentPageChanged();
    void popupVisibleChanged();
    void accountNameChanged();
    void statusTitleChanged();
    void statusSubtitleChanged();
    void syncingCountChanged();

private:
    void seedScenario();
    void refreshDerivedState();
    void repositionPopup();
    void setCurrentPage(const QString &page);
    void setPopupVisible(bool visible);

    QString m_currentPage = QStringLiteral("home");
    bool m_popupVisible = false;
    QString m_accountName = QStringLiteral("Nextcloud Desktop Client");
    QString m_statusTitle;
    QString m_statusSubtitle;
    int m_syncingCount = 0;
    int m_idleCycles = 0;
    QPointer<QQuickWindow> m_popupWindow;
    QPointer<QSystemTrayIcon> m_trayIcon;
    QuickActionsModel m_quickActionsModel;
    SyncActivityModel m_syncActivityModel;
    QTimer m_scenarioTimer;
};
