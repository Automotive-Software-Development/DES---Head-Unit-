import QtQuick 2.0
import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6

Item {
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
        id: mapLayoutForBack
        width: parent.width
    }
    Rectangle {
        anchors{
            top: mapLayoutForBack.top
            topMargin: 40
            left: mapLayoutForBack.left
            bottom: bottomLine.top
        }
        height: parent.height
        width: parent.width
        Plugin {
            id: mapPlugin
            name: "osm"
            PluginParameter {
                name: "osm.mapping.custom.host"
                value: "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=32f00f588ac64abeb9c7096c88595efd"
            }
        }
        Map {
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(52.4267619, 10.7869523)
            zoomLevel: 14
            MapQuickItem {
                coordinate: QtPositioning.coordinate(52.4267619, 10.7869523) // 42Wolfsburg
                sourceItem: Image {
                    source: "qrc:/assets/Images/Marker.svg"
                    width: 22
                    height: 37
                }
                anchorPoint.x: sourceItem.width / 2
                anchorPoint.y: sourceItem.height
            }
        }
    }
}


