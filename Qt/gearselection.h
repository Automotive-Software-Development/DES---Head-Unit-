#ifndef GEARSELECTION_H
#define GEARSELECTION_H
#include <QObject>

class GearSelection: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString gear READ gear NOTIFY gearChanged FINAL)
public:
    GearSelection(QObject *parent = nullptr);
    Q_INVOKABLE QString receiveGearInformation();
    Q_INVOKABLE void setGear(const QString &argument);

public slots:
    QString gear();

signals:
    void gearChanged();

private:
    QString m_gear;
};

#endif // GEARSELECTION_H
