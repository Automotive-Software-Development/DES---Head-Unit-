#ifndef SPEEDRECEIVER_H
#define SPEEDRECEIVER_H

#include <QObject>

class SpeedReceiver: public QObject
{
    Q_OBJECT
    Q_PROPERTY(float speed READ speed NOTIFY speedChanged FINAL)
public:
    explicit SpeedReceiver(QObject *parent = nullptr);
    Q_INVOKABLE float receiveSpeedData();

public slots:
    float speed();

signals:
    void speedChanged();

private:
    float m_speed;
};

#endif // SPEEDRECEIVER_H
