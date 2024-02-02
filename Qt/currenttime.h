#ifndef CURRENTTIME_H
#define CURRENTTIME_H
#include <QObject>

class CurrentTime : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentTime READ updateCurrentTime NOTIFY currentTimeChanged FINAL);
public:
    explicit CurrentTime(QObject *parent = nullptr);
    Q_INVOKABLE QString getCurrentTime();

public slots:
    QString updateCurrentTime();

signals:
    void currentTimeChanged();

private:
    QString m_currentTime;
};

#endif // CURRENTTIME_H
