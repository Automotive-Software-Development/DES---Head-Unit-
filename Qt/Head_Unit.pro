QT += quick multimedia dbus core quickcontrols2 widgets network positioning network positioning

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        ambientlight.cpp \
        appmodel.cpp \
        currenttime.cpp \
        main.cpp \
        socketclient.cpp \
        socketclientforspeed.cpp

RESOURCES += qml.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/positioning/weatherinfo
INSTALLS += target

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    ambientlight.h \
    appmodel.h \
    currenttime.h \
    socketclient.h \
    socketclientforspeed.h

QT_DEBUG_PLUGINS=1

DISTFILES +=

LIBS += -lssl -lcrypto

INCLUDEPATH+=/usr/lib/x86_64-linux-gnu
# LIBS+=/usr/lib/x86_64-linux-gnu
