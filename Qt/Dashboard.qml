import QtQuick 2.15

Item {
    id: dashboardLayout
    Text {
        id: dashboardTime
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter // change it later
        text: main.currentTime
        font.pointSize: 150
        color: "#fff"
    }

    // Music
    Rectangle {
        height: 130
        width: 100
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 256
        anchors.top: parent.verticalCenter
        anchors.topMargin: 150
        color: "transparent"
        Rectangle {
            id: music
            width: parent.width
            height: 100
            radius: 50
            opacity: 0.2
        }
        Image {
            source: "qrc:/assets/Images/Music.svg"
            anchors.centerIn: music
            height: 60
            width: 60
        }
        Text {
            id: musicText
            text: "Music"
            color: "#fff"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.bold: true
            font.pointSize: 18
        }

        // Handle Click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Music touched");
                main.componentSource = "AudioLayout.qml";
            }
        }
    }

    // Video
    Rectangle {
        height: 130
        width: 100
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 150
        color: "transparent"
        Rectangle {
            id: video
            width: parent.width
            height: 100
            radius: 50
            opacity: 0.2
        }
        Image {
            source: "qrc:/assets/Images/Video.svg"
            anchors.centerIn: video
            height: 60
            width: 60

        }
        Text {
            id: videoText
            text: "Video"
            color: "#fff"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.bold: true
            font.pointSize: 18
        }

        // Handle Click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Video touched");
                main.componentSource = "VideoLayout.qml";
            }
        }
    }

    // Settings
    Rectangle {
        height: 130
        width: 100
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 256
        anchors.top: parent.verticalCenter
        anchors.topMargin: 150
        color: "transparent"
        Rectangle {
            id: settings
            width: parent.width
            height: 100
            radius: 50
            opacity: 0.2
        }
        Image {
            source: "qrc:/assets/Images/Settings.svg"
            anchors.centerIn: settings
            height: 60
            width: 60
        }
        Text {
            id: settingsText
            text: "Settings"
            color: "#fff"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.bold: true
            font.pointSize: 18
        }

        // Handle Click
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Settings touched");
                main.componentSource = "Settings.qml";
            }
        }
    }
}
