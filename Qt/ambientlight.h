#ifndef AMBIENTLIGHT_H
#define AMBIENTLIGHT_H
#include <QObject>

class AmbientLight: public QObject
{
    Q_OBJECT
public:
    AmbientLight(QObject *parent = nullptr);
    Q_INVOKABLE void setThemeColor(const QString &argument);
};

#endif // AMBIENTLIGHT_H
