import QtQuick 2.15

Item {
    id: backLayout

    Rectangle {
        id: separator
        width: parent.width
        height: 1
        color: "#fff"
        anchors.top: parent.top
        anchors.topMargin: 40
    }

    Text {
        id: backLayoutTime
        text: main.currentTime
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        font.pointSize: 20
        color: "#fff"
    }

    Image {
        source: "qrc:/assets/Images/Back.svg"
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 10
        height: 25
        width: 40 // need to check on real display

        // Handle Click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Back Icon touched");
                main.componentSource = "Dashboard.qml";
            }
        }
    }
}
