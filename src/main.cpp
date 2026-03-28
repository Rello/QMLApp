#include <QAction>
#include <QApplication>
#include <QCoreApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMenu>
#include <QQuickStyle>
#include <QSystemTrayIcon>

#include "appcontroller.h"

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

    QSystemTrayIcon trayIcon(QIcon(QStringLiteral(":/qml/icons/tray-cloud.svg")));
    trayIcon.setToolTip(QStringLiteral("CloudPane Prototype"));

    QMenu trayMenu;
    auto *openAction = trayMenu.addAction(QStringLiteral("Open Prototype"));
    QObject::connect(openAction, &QAction::triggered, &controller, &AppController::togglePopup);

    trayMenu.addSeparator();

    auto *quitAction = trayMenu.addAction(QStringLiteral("Quit"));
    QObject::connect(quitAction, &QAction::triggered, &app, &QCoreApplication::quit);

    trayIcon.setContextMenu(&trayMenu);
    controller.setTrayIcon(&trayIcon);

    QObject::connect(&trayIcon, &QSystemTrayIcon::activated, &controller,
        [&controller](QSystemTrayIcon::ActivationReason reason) {
            if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick) {
                controller.togglePopup();
            }
        });

    trayIcon.show();

    return app.exec();
}

