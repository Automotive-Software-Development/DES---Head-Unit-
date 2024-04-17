import QtQuick 2.15

Item {
    id: backLayout
    Image {
        source: "qrc:/assets/Images/Back.svg"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10
        height: 25
        width: 40
        // Handle Click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Back Icon touched");
                main.componentSource = "Dashboard2.qml";
            }
        }
    }
}
