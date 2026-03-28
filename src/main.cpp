#include <QAction>
#include <QApplication>
#include <QCoreApplication>
#include <QCursor>
#include <QIcon>
#include <QPainter>
#include <QPixmap>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMenu>
#include <QQuickStyle>
#include <QSystemTrayIcon>

#include "appcontroller.h"

namespace {
QIcon createTrayIcon()
{
    QPixmap pixmap(22, 22);
    pixmap.fill(Qt::transparent);

    QPainter painter(&pixmap);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setPen(Qt::NoPen);

    painter.setBrush(QColor("#4DBDFF"));
    painter.drawEllipse(QRectF(3.0, 9.0, 8.5, 7.0));
    painter.drawEllipse(QRectF(7.5, 6.2, 8.5, 9.3));
    painter.drawEllipse(QRectF(12.0, 8.8, 6.8, 6.3));
    painter.drawRoundedRect(QRectF(4.0, 11.0, 13.2, 4.6), 2.4, 2.4);

    painter.setBrush(QColor(255, 255, 255, 75));
    painter.drawEllipse(QRectF(7.6, 7.0, 5.4, 3.0));

    painter.end();
    return QIcon(pixmap);
}

}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(false);

    QCoreApplication::setApplicationName(QStringLiteral("CloudPane Prototype"));
    QCoreApplication::setOrganizationName(QStringLiteral("Rello"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("rello.dev"));

    QQuickStyle::setStyle(QStringLiteral("Basic"));

    AppController controller;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("appController"), &controller);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() {
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("CloudPane"), QStringLiteral("Main"));
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    QSystemTrayIcon trayIcon(createTrayIcon());
    trayIcon.setToolTip(QStringLiteral("CloudPane Prototype"));

    QMenu trayMenu;
    trayMenu.setSeparatorsCollapsible(false);

    auto *accountAction = trayMenu.addAction(controller.accountName());
    accountAction->setEnabled(false);

    trayMenu.addSeparator();

    auto *statusAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/status-check.svg")),
        controller.statusTitle());
    QObject::connect(statusAction, &QAction::triggered, &controller, [&controller]() {
        controller.showActivity();
        controller.showPopup();
    });

    auto *storageAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/plus.svg")),
        QStringLiteral("Get More Storage"));
    QObject::connect(storageAction, &QAction::triggered, &controller, [&controller]() {
        controller.showHome();
        controller.showPopup();
    });

    trayMenu.addSeparator();

    auto *filesAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/files.svg")),
        QStringLiteral("Files"));
    QObject::connect(filesAction, &QAction::triggered, &controller, [&controller]() {
        controller.triggerAction(QStringLiteral("files"));
        controller.showPopup();
    });

    auto *addAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/plus.svg")),
        QStringLiteral("Add"));
    QObject::connect(addAction, &QAction::triggered, &controller, [&controller]() {
        controller.triggerAction(QStringLiteral("add"));
    });

    auto *settingsAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/settings.svg")),
        QStringLiteral("Settings"));
    QObject::connect(settingsAction, &QAction::triggered, &controller, [&controller]() {
        controller.triggerAction(QStringLiteral("settings"));
        controller.showPopup();
    });

    auto *moreAction = trayMenu.addAction(
        QIcon(QStringLiteral(":/qml/icons/more.svg")),
        QStringLiteral("More"));
    QObject::connect(moreAction, &QAction::triggered, &controller, [&controller]() {
        controller.triggerAction(QStringLiteral("more"));
        controller.showPopup();
    });

    trayMenu.addSeparator();

    auto *openPopupAction = trayMenu.addAction(QStringLiteral("Open Custom Preview"));
    QObject::connect(openPopupAction, &QAction::triggered, &controller, [&controller]() {
        controller.showHome();
        controller.showPopup();
    });

    auto *quitAction = trayMenu.addAction(QStringLiteral("Quit"));
    QObject::connect(quitAction, &QAction::triggered, &app, &QCoreApplication::quit);

    controller.setTrayIcon(&trayIcon);

    QObject::connect(&controller, &AppController::statusTitleChanged, &trayMenu, [&controller, statusAction]() {
        statusAction->setText(controller.statusTitle());
    });

    QObject::connect(&trayIcon, &QSystemTrayIcon::activated, &controller,
        [&controller, &trayMenu](QSystemTrayIcon::ActivationReason reason) {
            if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick) {
                controller.togglePopup();
            } else if (reason == QSystemTrayIcon::Context) {
                trayMenu.popup(QCursor::pos());
            }
        });

    trayIcon.show();

    return app.exec();
}
