import QtQuick 2.15

Item {
    id: gearSelectionMenu
    Rectangle {
        id: currentGear
        visible: !showGearMenu
        opacity: 0.4
        width: 40
        height: width
        radius: width * 0.5
        border.color: "#fff"
        border.width: 2
        color: "transparent"
        anchors{
            bottom: parent.bottom
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: socketClient.gear
            color: "#fff"
            font.pointSize: 25
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Current Gear Selected");
                showGearMenu = true;
            }
        }
    }
    Gear {
        width: 150
        height: currentGear.height
        anchors{
            bottom: parent.bottom
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        defaultFontSize: 25
        visible: showGearMenu
    }

    property bool showGearMenu: false;
    property bool showBackButton: false;
}
