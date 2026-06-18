#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>

#include "taskmanager.h"
#include "timelinemodel.h"
#include "logger.h"

int main(int argc, char *argv[])
{
    // Initialize logger first
    Logger::instance()->info("App", QStringLiteral("Application starting"));

    QGuiApplication app(argc, argv);
    app.setOrganizationName("TodoApp");
    app.setApplicationName("Todo Timeline");
    app.setApplicationVersion("1.1.0");

    // Set style
    QQuickStyle::setStyle("Material");

    // Create core objects
    TaskManager taskManager;
    TimelineModel timelineModel;

    // Create QML engine
    QQmlApplicationEngine engine;

    // Register types to QML
    engine.rootContext()->setContextProperty("taskManager", &taskManager);
    engine.rootContext()->setContextProperty("timelineModel", &timelineModel);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            Logger::instance()->error("App", QStringLiteral("Failed to load QML"));
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        Logger::instance()->error("App", QStringLiteral("No root objects loaded"));
        return -1;
    }

    Logger::instance()->info("App", QStringLiteral("Application ready"));
    return app.exec();
}
