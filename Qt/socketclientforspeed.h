#ifndef SOCKETCLIENTFORSPEED_H
#define SOCKETCLIENTFORSPEED_H

#include <QObject>
#include <QTcpSocket>

class SocketClientForSpeed : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString rps READ rps NOTIFY rpsReceived)
public:
    explicit SocketClientForSpeed(QObject *parent = nullptr);
    Q_INVOKABLE void connectToServer();
    QString rps() const;

signals:
    void rpsReceived(const QString &speed);

private slots:
    void connected();
    void disconnected();
    void readyRead();

private:
    QTcpSocket socket;
    QString m_rps;
};

#endif // SOCKETCLIENTFORSPEED_H
