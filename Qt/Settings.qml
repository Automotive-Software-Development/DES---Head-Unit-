import QtQuick 2.15

Item {
    id: settingsLayout
    Rectangle {
        width: parent.width
        height: parent.height

        gradient: Gradient {
            GradientStop { position: 0.04; color: "skyblue" } // Dark Blue
            GradientStop { position: 1.0; color: "#000000" } // Black
        }
        opacity: 0.7
    }
}
