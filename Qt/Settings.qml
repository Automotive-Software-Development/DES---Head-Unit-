import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.15

Item {
    id: calendarLayout
    width: parent.width
    height: parent.height
    GearMenu {
        id: gearMenu
        width: parent.width
        height: parent.height
    }
    Rectangle {
        id: topLine
        anchors.top: parent.top
        anchors.topMargin: 40
        width: parent.width
        border.color: "#fff"
        height: 1
    }
    Rectangle {
        id: bottomLine
        anchors {
            bottom: parent.bottom
            bottomMargin: 55
        }
        border.color: "#fff"
        width: parent.width
        height: 1
    }
    Back {
        id: settingsLayoutForBack
        width: parent.width
    }

    ScrollView {
        width: parent.width
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.visible: false
        anchors {
            left: parent.left
            leftMargin: 200
            right: parent.right
            rightMargin: 200
            top: topLine.bottom
            topMargin: 20
            bottom: bottomLine.top
            bottomMargin: 20
        }
        contentWidth: parent.width - 420
        Column {
            width: parent.width
            spacing: 20
            Text {
                id: styleText
                text: "Ambient Lighting"
                color: "#fff"
                font.pointSize: 18
                anchors.left: parent.left
            }
            Rectangle {
                id: mainRectangle
                width: parent.width
                height: 320
                color: "transparent"
                border.color: "gray"
                radius: 20
                Rectangle {
                    id: selectedColor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 15
                    }
                    border.color: themeColor
                    border.width: 5
                    color: "transparent"
                    width: parent.width * 0.5
                    height: parent.height * 0.7
                    radius: parent.radius
                    Rectangle {
                        anchors{
                            top: parent.top
                            topMargin: 15
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: parent.width * 0.5
                        height: parent.height * 0.9
                        gradient: Gradient{
                            GradientStop { position: 0.01; color: themeColor }
                            GradientStop { position: 1.0; color: "#000" }
                        }
                        opacity: 0.8
                        radius: 20
                    }
                }
                Rectangle {
                    id: horizontalSeparator
                    anchors {
                        top: selectedColor.bottom
                        topMargin: 15
                    }
                    width: parent.width
                    height: 1
                    color: "transparent"
                    border.color: "gray"
                }

                Text {
                    id: colorText
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 20
                        left: parent.left
                        leftMargin: 20
                    }
                    text: "Color"
                    color: "#fff"
                    font.pointSize: 16
                }
                ListView {
                    model: colors
                    orientation: ListView.Horizontal
                    width: parent.width
                    anchors {
                        top: horizontalSeparator.bottom
                        bottom: parent.bottom
                        left: colorText.right
                        leftMargin: 30
                    }
                    delegate: Item {
                        width: 75
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            id: outerColor
                            visible: themeColor === modelData
                            anchors.verticalCenter: parent.verticalCenter
                            width: 38
                            height: width
                            radius: width * 0.5
                            color: "transparent"
                            border.color: modelData
                            border.width: 2
                        }
                        Rectangle {
                            anchors.centerIn: outerColor
                            width: 30
                            height: width
                            radius: width * 0.5
                            color: modelData
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("=======================================Setting new theme color====================================");
                                    AmbientLight.setThemeColor(modelData);
                                    themeColor = modelData;
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                color: "transparent"
                height: 10
                width: parent.width
            }
            Text {
                id: powerText
                text: "About"
                color: "#fff"
                font.pointSize: 18
            }
            Rectangle {
                width: parent.width
                height: 240
                color: "transparent"
                border.color: "gray"
                radius: 20
                Image {
                    id: logo
                    source: "qrc:/assets/Images/SeaMe.png"
                    width: 100
                    height: 100
                    anchors {
                        top: parent.top
                        topMargin: 20
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle {
                    id: separator1
                    width: parent.width
                    height: 1
                    color: "gray"
                    anchors {
                        top: logo.bottom
                        topMargin: 15
                    }
                }
                Row {
                    id: nameRow
                    anchors {
                        top: separator1.bottom
                        left: parent.left
                        leftMargin: 20
                        right: parent.right
                        rightMargin: 20
                    }
                    height: 50
                    spacing: 150
                    Text {
                        anchors {
                            top: parent.top
                            topMargin: 10
                        }
                        text: "Name"
                        color: "#fff"
                        font.pointSize: 14
                    }
                    Rectangle {
                        height: parent.height
                        width: 1
                        color: "gray"
                    }
                    Text {
                        anchors {
                            top: parent.top
                            topMargin: 10
                        }
                        text: "SEA:ME"
                        color: "#fff"
                        font.pointSize: 14
                    }
                }
                Rectangle {
                    id: separator2
                    width: parent.width
                    height: 1
                    color: "gray"
                    anchors {
                        top: nameRow.bottom
                    }
                }
                Row {
                    id: developersRow
                    anchors {
                        top: separator2.bottom
                        left: parent.left
                        leftMargin: 20
                        right: parent.right
                        rightMargin: 20
                    }
                    height: 50
                    spacing: 103
                    Text {
                        anchors {
                            top: parent.top
                            topMargin: 10
                        }
                        text: "Developers"
                        color: "#fff"
                        font.pointSize: 14
                    }
                    Rectangle {
                        height: parent.height
                        width: 1
                        color: "gray"
                    }
                    Text {
                        anchors {
                            top: parent.top
                            topMargin: 10
                        }
                        text: "Charmi, Krunal, Abhinav"
                        color: "#fff"
                        font.pointSize: 14
                    }
                }
            }
        }
    }

    property var colors: ["#00f", "gray", "#891652", "#7E6363", "green", "#B67352"];
}
