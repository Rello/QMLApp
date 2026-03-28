#include "appcontroller.h"

#include <QGuiApplication>
#include <QQuickWindow>
#include <QScreen>
#include <QSystemTrayIcon>

namespace {
QVector<SyncItem> initialSyncItems()
{
    return {
        {
            QStringLiteral("Program Evaluation Report.docx"),
            QStringLiteral("Quarterly narrative update"),
            QStringLiteral("W"),
            QStringLiteral("syncing"),
            {},
            1.6,
            4.0,
            0.45,
        },
        {
            QStringLiteral("Budget Report.xlsx"),
            QStringLiteral("Finance workspace"),
            QStringLiteral("X"),
            QStringLiteral("syncing"),
            {},
            0.37,
            1.9,
            0.24,
        },
        {
            QStringLiteral("Product Storytelling.pptx"),
            QStringLiteral("Narrative deck"),
            QStringLiteral("P"),
            QStringLiteral("complete"),
            QStringLiteral("Uploaded \xc2\xb7 21 minutes ago"),
            2.8,
            2.8,
            0.0,
        },
    };
}
}

AppController::AppController(QObject *parent)
    : QObject(parent)
    , m_quickActionsModel(this)
    , m_syncActivityModel(this)
{
    m_quickActionsModel.setItems({
        { QStringLiteral("files"), QStringLiteral("Files"), QStringLiteral("□") },
        { QStringLiteral("add"), QStringLiteral("Add"), QStringLiteral("+") },
        { QStringLiteral("settings"), QStringLiteral("Settings"), QStringLiteral("⚙") },
        { QStringLiteral("more"), QStringLiteral("More"), QStringLiteral("⋯") },
    });

    seedScenario();

    m_scenarioTimer.setInterval(1200);
    connect(&m_scenarioTimer, &QTimer::timeout, this, &AppController::advanceScenario);
    m_scenarioTimer.start();
}

QString AppController::currentPage() const
{
    return m_currentPage;
}

bool AppController::popupVisible() const
{
    return m_popupVisible;
}

QString AppController::accountName() const
{
    return m_accountName;
}

QString AppController::statusTitle() const
{
    return m_statusTitle;
}

QString AppController::statusSubtitle() const
{
    return m_statusSubtitle;
}

int AppController::syncingCount() const
{
    return m_syncingCount;
}

QObject *AppController::syncActivityModel()
{
    return &m_syncActivityModel;
}

QObject *AppController::quickActionsModel()
{
    return &m_quickActionsModel;
}

void AppController::togglePopup()
{
    setPopupVisible(!m_popupVisible);
}

void AppController::hidePopup()
{
    setPopupVisible(false);
}

void AppController::showHome()
{
    setCurrentPage(QStringLiteral("home"));
}

void AppController::showActivity()
{
    setCurrentPage(QStringLiteral("activity"));
}

void AppController::triggerAction(const QString &id)
{
    if (id == QStringLiteral("files")) {
        showActivity();
        return;
    }

    if (id == QStringLiteral("add")) {
        advanceScenario();
        return;
    }

    if (id == QStringLiteral("settings")) {
        showHome();
        return;
    }

    if (id == QStringLiteral("more")) {
        if (m_syncActivityModel.archiveCompletedItem()) {
            refreshDerivedState();
        }
    }
}

void AppController::advanceScenario()
{
    if (m_syncActivityModel.activeTransferCount() > 0) {
        m_syncActivityModel.advanceSimulation();
        m_idleCycles = 0;
    } else {
        ++m_idleCycles;
        if (m_idleCycles >= 5) {
            seedScenario();
            m_idleCycles = 0;
            return;
        }
    }

    refreshDerivedState();
}

void AppController::registerPopup(QObject *windowObject)
{
    auto *window = qobject_cast<QQuickWindow *>(windowObject);
    if (!window || m_popupWindow == window) {
        return;
    }

    m_popupWindow = window;
    m_popupWindow->setColor(Qt::transparent);
    m_popupWindow->setFlags(Qt::Tool | Qt::FramelessWindowHint | Qt::WindowStaysOnTopHint);

    connect(m_popupWindow.data(), &QQuickWindow::activeChanged, this, [this]() {
        if (m_popupWindow && !m_popupWindow->isActive() && m_popupVisible) {
            hidePopup();
        }
    });
}

void AppController::setTrayIcon(QSystemTrayIcon *trayIcon)
{
    m_trayIcon = trayIcon;
}

void AppController::seedScenario()
{
    m_syncActivityModel.setItems(initialSyncItems());
    refreshDerivedState();
}

void AppController::refreshDerivedState()
{
    const int newSyncingCount = m_syncActivityModel.activeTransferCount();
    const QString newStatusTitle = newSyncingCount > 0
        ? QStringLiteral("Syncing %1 %2").arg(newSyncingCount).arg(newSyncingCount == 1 ? QStringLiteral("file") : QStringLiteral("files"))
        : QStringLiteral("Backed up and synced");
    const QString newStatusSubtitle = newSyncingCount > 0
        ? m_syncActivityModel.aggregateProgressText()
        : QStringLiteral("Everything is ready across your key folders.");

    if (m_syncingCount != newSyncingCount) {
        m_syncingCount = newSyncingCount;
        emit syncingCountChanged();
    }

    if (m_statusTitle != newStatusTitle) {
        m_statusTitle = newStatusTitle;
        emit statusTitleChanged();
    }

    if (m_statusSubtitle != newStatusSubtitle) {
        m_statusSubtitle = newStatusSubtitle;
        emit statusSubtitleChanged();
    }
}

void AppController::repositionPopup()
{
    if (!m_popupWindow) {
        return;
    }

    const QRect trayRect = m_trayIcon ? m_trayIcon->geometry() : QRect();
    QScreen *screen = trayRect.isValid()
        ? QGuiApplication::screenAt(trayRect.center())
        : QGuiApplication::primaryScreen();

    if (!screen) {
        return;
    }

    const QRect availableGeometry = screen->availableGeometry();
    QSize popupSize = m_popupWindow->size();
    if (!popupSize.isValid() || popupSize.isEmpty()) {
        popupSize = m_popupWindow->minimumSize();
    }

    int x = availableGeometry.right() - popupSize.width() - 20;
    int y = availableGeometry.top() + 28;

    if (trayRect.isValid()) {
        x = trayRect.center().x() - popupSize.width() / 2;
        y = trayRect.bottom() + 10;
    }

    x = qBound(availableGeometry.left() + 16, x, availableGeometry.right() - popupSize.width() - 16);
    y = qBound(availableGeometry.top() + 12, y, availableGeometry.bottom() - popupSize.height() - 16);

    m_popupWindow->setPosition(x, y);
}

void AppController::setCurrentPage(const QString &page)
{
    if (m_currentPage == page) {
        return;
    }

    m_currentPage = page;
    emit currentPageChanged();

    if (m_popupVisible) {
        repositionPopup();
    }
}

void AppController::setPopupVisible(bool visible)
{
    if (m_popupVisible == visible) {
        return;
    }

    m_popupVisible = visible;

    if (m_popupWindow) {
        if (visible) {
            repositionPopup();
            m_popupWindow->show();
            m_popupWindow->raise();
            m_popupWindow->requestActivate();
        } else {
            m_popupWindow->hide();
        }
    }

    emit popupVisibleChanged();
}
