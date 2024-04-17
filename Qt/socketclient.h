#ifndef SOCKETCLIENT_H
#define SOCKETCLIENT_H

#include <QObject>
#include <QTcpSocket>

class SocketClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString gear READ gear NOTIFY gearReceived)
public:
    explicit SocketClient(QObject *parent = nullptr);
    Q_INVOKABLE void connectToServer();
    QString gear() const;
    void getGear();
    Q_INVOKABLE void setGear(const QString &argument);

signals:
    void gearReceived(const QString &gear);

private slots:
    void connected();
    void disconnected();
    void readyRead();

private:
    QTcpSocket socket;
    QString m_gear;
};

#endif // SOCKETCLIENT_H
