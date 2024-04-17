import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: timeLayout
    width: parent.width
    height: parent.height

    Back {
        id: timeLayoutForBack
        width: parent.width
    }
    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: themeColor }
            GradientStop { position: 0.4; color: "transparent" }
            GradientStop { position: 1.0; color: "#000" }
        }
    }
    Text {
        id: time
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: main.currentTime.split(":")[0] + ":" + main.currentTime.split(":")[1]
        font.pointSize: 150
        color: "#fff"
    }
    GearMenu {
        width: parent.width
        height: parent.height
    }
}
