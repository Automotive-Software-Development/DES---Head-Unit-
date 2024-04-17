import QtQuick 2.15

Item {
    width: parent.width
    height: parent.height
    // top border
    Rectangle {
        width: parent.width
        height: 1
        anchors.top: parent.top
        color: "#fff"
    }
    // left border
    Rectangle {
        width: 1
        height: parent.height
        anchors.top: parent.top
        color: "#fff"
    }
    // right border
    Rectangle {
        width: 1
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#fff"
        // opacity: 0.2
    }
    // bottom border
    Rectangle {
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: "#fff"
        // opacity: 0.2
    }
}
