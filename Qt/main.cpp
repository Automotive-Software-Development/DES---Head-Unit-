#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <currenttime.h>
#include <QQmlContext>
#include <ambientlight.h>
#include <socketclient.h>
#include <socketclientforspeed.h>
#include <QQuickWindow>
//! [0]
#include "appmodel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    CurrentTime obj;
    QObject::connect(&obj, SIGNAL(currentTimeChanged()), &obj, SLOT(updateCurrentTime()));
    QQmlContext * rootContext = engine.rootContext();
    rootContext->setContextProperty("Head_Unit", &obj);

    AmbientLight colorObj;
    QQmlContext * rootContext3 = engine.rootContext();
    rootContext3->setContextProperty("AmbientLight", &colorObj);

    SocketClient socketObj;
    QQmlContext * rootContext5 = engine.rootContext();
    rootContext5->setContextProperty("socketClient", &socketObj);

    SocketClientForSpeed socketObjForSpeed;
    QQmlContext * rootContext6 = engine.rootContext();
    rootContext6->setContextProperty("socketClientForSpeed", &socketObjForSpeed);

    qmlRegisterType<WeatherData>("WeatherInfo", 1, 0, "WeatherData");
    qmlRegisterType<AppModel>("WeatherInfo", 1, 0, "AppModel");

    //! [0]
    qRegisterMetaType<WeatherData>();

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    if (!engine.rootObjects().isEmpty()) {
        auto window = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
        if (window) {
            // window->showFullScreen();
        }
    }

    return app.exec();
}
