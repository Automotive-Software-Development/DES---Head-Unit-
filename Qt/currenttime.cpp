#include "currenttime.h"
#include <QTimer>
#include <QTime>
#include <QDebug>

CurrentTime::CurrentTime(QObject *parent)
    : QObject{parent} {

    getCurrentTime();

    QTimer *timer1 = new QTimer(this);
    connect(timer1, &QTimer::timeout, this, &CurrentTime::getCurrentTime);
    timer1->start(1000);
}

QString CurrentTime::getCurrentTime()
{
    QString updatedTime = QTime::currentTime().toString("hh:mm");
    m_currentTime = updatedTime;
    emit currentTimeChanged();
    // qDebug() << "Time in cpp: " << updatedTime;m`                `
    return updatedTime;
}

QString CurrentTime::updateCurrentTime()
{
    return m_currentTime;
}
