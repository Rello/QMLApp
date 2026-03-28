#include <QAction>
#include <QApplication>
#include <QCoreApplication>
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
