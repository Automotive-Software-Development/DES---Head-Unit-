#include "socketclientforspeed.h"

SocketClientForSpeed::SocketClientForSpeed(QObject *parent) : QObject(parent) {
    connect(&socket, &QTcpSocket::connected, this, &SocketClientForSpeed::connected);
    connect(&socket, &QTcpSocket::disconnected, this, &SocketClientForSpeed::disconnected);
    connect(&socket, &QTcpSocket::readyRead, this, &SocketClientForSpeed::readyRead);
    connectToServer();
}

void SocketClientForSpeed::connectToServer()
{
    quint16 port = 4000;
    socket.connectToHost("192.168.1.125", port);
}

QString SocketClientForSpeed::rps() const
{
    return m_rps;
}

void SocketClientForSpeed::connected()
{
    qDebug() << "Connected to server 4000 to receive rps";
    // Send request to server
    // socket.write("GET_GEAR");
    // socket.waitForBytesWritten();
}

void SocketClientForSpeed::disconnected()
{
    qDebug() << "Disconnected from server 4000";
    socket.close();
}

void SocketClientForSpeed::readyRead()
{
    qDebug() << "Reading speed color from server";
    QByteArray data = socket.readAll();
    qDebug() << data << "socket data";
    m_rps = QString::fromUtf8(data);
    qDebug() << m_rps << "converted socket data";
    emit rpsReceived(m_rps);
}
