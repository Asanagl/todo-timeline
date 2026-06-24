#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QStandardPaths>
#include <QIcon>
#include <QFont>

#include "taskmanager.h"
#include "timelinemodel.h"
#include "thememanager.h"
#include "logger.h"

int main(int argc, char *argv[])
{
    // 在沙箱/测试环境中通过环境变量覆盖数据目录，并启用 Qt 测试模式以避免写入系统缓存路径
    if (qEnvironmentVariableIsSet("TODO_APP_DATA_DIR")) {
        QStandardPaths::setTestModeEnabled(true);
    }

    QGuiApplication app(argc, argv);
    app.setOrganizationName("TodoApp");
    app.setApplicationName("Todo Timeline");
    app.setApplicationVersion("1.3.0");

    // 设置全局字体：优先 MiSans，回退 JetBrains Mono / Microsoft YaHei / Segoe UI
    QFont defaultFont;
    defaultFont.setFamilies({"MiSans", "JetBrains Mono", "Microsoft YaHei", "Segoe UI"});
    defaultFont.setPointSize(10);
    defaultFont.setStyleHint(QFont::SansSerif);
    defaultFont.setStyleStrategy(QFont::PreferAntialias);
    app.setFont(defaultFont);

    // Initialize logger after QApplication setup
    Logger::instance()->info("App", QStringLiteral("Application starting"));

    // Set style
    QQuickStyle::setStyle("Material");

    // Create core objects
    TaskManager taskManager;
    TimelineModel timelineModel;
    ThemeManager themeManager;

    // Create QML engine
    QQmlApplicationEngine engine;

    // Register types to QML
    engine.rootContext()->setContextProperty("taskManager", &taskManager);
    engine.rootContext()->setContextProperty("timelineModel", &timelineModel);
    engine.rootContext()->setContextProperty("themeManager", &themeManager);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            Logger::instance()->error("App", QStringLiteral("Failed to load QML"));
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    QObject::connect(&engine, &QQmlApplicationEngine::warnings,
                     &app, [](const QList<QQmlError> &warnings) {
        for (const auto &warning : warnings) {
            Logger::instance()->error("QML", warning.toString());
        }
    });

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        Logger::instance()->error("App", QStringLiteral("No root objects loaded"));
        return -1;
    }

    Logger::instance()->info("App", QStringLiteral("Application ready"));
    return app.exec();
}
