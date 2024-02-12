import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Window {
    id: main
    width: 1024
    height: 600
    visible: true
    title: qsTr("Head Unit")

    Rectangle {
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "black"

        Item {
            width: parent.width
            height: parent.height

            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "gray" }
                    GradientStop { position: 0.05; color: "gray" }
                    GradientStop { position: 0.4; color: "transparent" }
                    GradientStop { position: 1.0; color: "black" }
                }
            }
        }

        // Item {
        //     width: parent.width
        //     height: parent.height
        //     Repeater {
        //         model: 25
        //         Rectangle {
        //             required property int index
        //             id: bubble
        //             width: Math.random() * 50 + 20
        //             height: width
        //             x: Math.random() * parent.width
        //             y: Math.random() * 150
        //             radius: width / 2
        //             color: "white"
        //             opacity: Math.random() * 0.5 + 0.1
        //         }
        //     }
        // }

        Loader {
            id: dynamicLayoutLoader
            anchors.fill: parent
            source: componentSource
        }
    }
    property string componentSource: "Dashboard.qml"
    property string currentTime: Head_Unit ? Head_Unit.currentTime : Qt.formatTime(new Date(),"hh:mm");
}
