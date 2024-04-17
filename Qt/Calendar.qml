import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

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
        id: audioLayoutForBack
        width: parent.width
    }
    Rectangle {
        width: parent.width
        height: parent.height
        anchors {
            top: topLine.bottom
            bottom: bottomLine.top
        }
        Calendar {
            id: calendar
            anchors.fill: parent
            locale: Qt.locale("en_US") // Set the locale (optional)
            selectedDate: new Date() // Set the initial selected date
            onSelectedDateChanged: {
                console.log("Selected date:", selectedDate)
            }
            style: CalendarStyle {
                gridVisible: false
                dayDelegate: Rectangle {
                    gradient: Gradient {
                        GradientStop {
                            position: 0.00
                            color: styleData.selected ? themeColor : (styleData.visibleMonth && styleData.valid ? "#000" : "#222");
                        }
                        GradientStop {
                            position: 1.00
                            color: styleData.selected ? "#444" : (styleData.visibleMonth && styleData.valid ? "#000" : "#222");
                        }
                        GradientStop {
                            position: 1.00
                            color: styleData.selected ? "#000" : (styleData.visibleMonth && styleData.valid ? "#000" : "#222");
                        }
                    }

                    Label {
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: styleData.visibleMonth && styleData.valid ? "#fff" : "#666"
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#444"
                        anchors.bottom: parent.bottom
                    }

                    Rectangle {
                        width: 1
                        height: parent.height
                        color: "#444"
                        anchors.right: parent.right
                    }
                }
                navigationBar: Rectangle {
                    color: themeColor
                    // Label {
                    //     text: styleData.title
                    //     anchors.centerIn: parent
                    //     color: "#fff"
                    // }
                }
            }
        }
    }
}
