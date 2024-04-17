#include "ambientlight.h"
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDebug>

AmbientLight::AmbientLight(QObject *parent)
    : QObject{parent}{}

void AmbientLight::setThemeColor(const QString &argument)
{
    qDebug() << "==========================Trying to connect D-Bus to set theme color==========================";
    QDBusInterface dbusInterface("com.example.dBus.ambientlight", "/com/example/dBus/ambientlight", "com.example.dBus.ambientlight", QDBusConnection::sessionBus());

    // Show error if connection is failed
    if(!dbusInterface.isValid()) {
        qDebug() << "Failed to create DBusInterface to set theme color";
    }

    // call dbus method to set the gear
    dbusInterface.call("setThemeColor", argument);
}
