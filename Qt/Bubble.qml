import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    // Rectangle {
    //     id: rec
    //     width: 300
    //     height: 300
    //     anchors.centerIn: parent
    //     radius: 150
    // }
    // RadialGradient {
    //     id: gradient
    //     anchors.fill: rec
    //     gradient: Gradient {
    //         GradientStop { position: 0.0; color: "black" } // Inner color (black)
    //         GradientStop { position: 1.0; color: "blue" } // Outer color (blue)
    //     }
    // }
    // OpacityMask {
    //     maskSource: gradient
    //     source: rec
    //     anchors.fill: rec
    // }
}

