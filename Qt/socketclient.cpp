#include "socketclient.h"
#include <QDebug>
#include <QTimer>

SocketClient::SocketClient(QObject *parent) : QObject(parent)
{
    connect(&socket, &QTcpSocket::connected, this, &SocketClient::connected);
    connect(&socket, &QTcpSocket::disconnected, this, &SocketClient::disconnected);
    connect(&socket, &QTcpSocket::readyRead, this, &SocketClient::readyRead);

    connectToServer();
}

void SocketClient::connectToServer()
{
    quint16 port = 3000;
    socket.connectToHost("192.168.1.125", port);
}

void SocketClient::connected()
{
    qDebug() << "Connected to server";
    // Send request to server
    socket.write("GET_GEAR");
    socket.waitForBytesWritten();
}

void SocketClient::disconnected()
{
    qDebug() << "Disconnected from server";
    socket.close();
}

void SocketClient::setGear(const QString &gear)
{
    qDebug() << "selcted gear in cpp" << gear;
    QByteArray data = "SET_GEAR," + gear.toUtf8(); // Combine "SET_GEAR" with the gear value
    socket.write(data);
    socket.waitForBytesWritten();
}

void SocketClient::readyRead()
{
    qDebug() << "Reading theme color from server";
    QByteArray data = socket.readAll();
    qDebug() << data << "socket data";
    m_gear = QString::fromUtf8(data);
    qDebug() << m_gear << "converted socket data";
    emit gearReceived(m_gear);
}

QString SocketClient::gear() const
{
    return m_gear;
}
