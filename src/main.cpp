#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "taskmanager.h"
#include "timelinemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("TodoApp");
    app.setApplicationName("Todo Timeline");
    app.setApplicationVersion("1.0.0");

    // 设置样式
    QQuickStyle::setStyle("Material");

    // 创建核心对象
    TaskManager taskManager;
    TimelineModel timelineModel;

    // 创建 QML 引擎
    QQmlApplicationEngine engine;

    // 注册类型到 QML
    engine.rootContext()->setContextProperty("taskManager", &taskManager);
    engine.rootContext()->setContextProperty("timelineModel", &timelineModel);

    // 加载主 QML 文件
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
