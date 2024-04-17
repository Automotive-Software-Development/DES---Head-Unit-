import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.15
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import "components"
import WeatherInfo 1.0

Item {
    height: parent.height
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors {
        top: parent.top
        topMargin: 25
    }
    Rectangle {
        id: timeRectangle
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: (parent.width / 4) - 10
        height: cardHeight
        color: "transparent"
        radius: 20
        Rectangle {
            id: timeRectangleShadow
            anchors.fill: timeRectangle
            gradient: Gradient{
                GradientStop { position: 0.01; color: themeColor }
                GradientStop { position: 1.0; color: "#000" }
            }
            opacity: cardBackgroundOpacity
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Time Card Touched");
                    main.componentSource = "Time.qml";
                }
            }
            radius: 20
        }
        Rectangle {
            id: clock
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 30
            }
            width: parent.width * 0.8
            height: width
            radius: width * 0.5
            color: "#fff"
            opacity: 0.8
            Rectangle {
                id: hourHand
                width: 4
                height: (clock.height * 0.5) - 25
                color: "#fff"
                border.color: "#fff"
                anchors {
                    top: parent.top
                    topMargin: 25
                    horizontalCenter: parent.horizontalCenter
                }
                transform: Rotation {
                    origin.x: hourHand.width / 2
                    origin.y: hourHand.height
                    angle: (main.currentTime.split(":")[0] % 12 + main.currentTime.split(":")[1] / 60) * 30
                }
            }
            Rectangle {
                id: minuteHand
                width: 4
                height: (clock.height * 0.5) - 10
                color: "#000"
                border.width: 3
                border.color: "#000"
                anchors {
                    top: parent.top
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                transform: Rotation {
                    origin.x: minuteHand.width / 2
                    origin.y: minuteHand.height
                    angle: (main.currentTime.split(":")[1] % 60) * 6
                }
            }
            Rectangle {
                id: secondHand
                width: 2
                height: clock.height * 0.5
                color: "red"
                border.width: 3
                border.color: "red"
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                transform: Rotation {
                    origin.x: secondHand.width
                    origin.y: secondHand.height
                    angle: (main.currentTime.split(":")[2] % 60) * 6
                }
            }
        }
        Rectangle {
            width: 10
            height: width
            radius: width * 0.5
            color: "gray"
            anchors.centerIn: clock
        }
        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: clock.bottom
                topMargin: 20
            }
            text: main.currentTime.split(":")[0] + ":" + main.currentTime.split(":")[1]
            font.pointSize: 24
            color: "#fff"
        }
    }


    Rectangle {
        id: musicRectangle
        anchors.left: timeRectangle.right
        anchors.leftMargin: 10
        width: (parent.width / 4) - 10
        height: cardHeight
        color: "transparent"
        radius: 20
        Rectangle {
            id: musicRectangleShadow
            anchors.fill: musicRectangle
            gradient: Gradient{
                GradientStop { position: 0.01; color: themeColor }
                GradientStop { position: 1.0; color: "#000" }
            }
            opacity: cardBackgroundOpacity
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Music Card Touched");
                    main.componentSource = "AudioLayout2.qml";
                }
            }
            radius: 20
        }
        // Audio Image
        Rectangle {
            id: audioImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            width: musicRectangle.width * 0.8
            height: width
            color: "transparent"
            border.width: 4
            border.color: "#fff"
            radius: 10
            Image {
                source: currentLogo ? currentLogo : "qrc:/assets/Images/Music.jpg"
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: width
                fillMode: Image.Stretch
            }
        }
        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: audioImage.bottom
                topMargin: 20
            }
            spacing: 30
            // Previous song
            Button {
                id: previousAudio
                height: 30
                width: 30
                background: Rectangle {
                    color: "transparent"
                }
                enabled: currentSongIndex > 0
                Image {
                    id: previousButton
                    source: "qrc:/assets/Images/Previous.svg"
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                }
                onClicked: {
                    console.log("Previous button clicked...")
                    if (currentSongIndex > 0) {
                        currentSongIndex--;
                        playCurrentItem();
                    }
                }
            }
            // Play or Pause
            Button {
                id: playOrPauseButton
                height: 30
                width: 30
                background: Rectangle {
                    color: "transparent"
                }
                Image {
                    id: playOrPause
                    source: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/assets/Images/Pause.svg" : "qrc:/assets/Images/Play.svg"
                    // source: "qrc:/assets/Images/Pause.svg"
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                }
                onClicked: {
                    if(!audioSelected) {
                        audioSelected = true;
                    }
                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                        mediaPlayer.pause();
                    } else {
                        mediaPlayer.source = audioListModel[currentSongIndex].url;
                        mediaPlayer.play();
                        currentLogo = audioListModel[currentSongIndex].logo;
                    }
                }
            }
            // Next Song
            Button {
                id: nextAudio
                height: 30
                width: 30
                background: Rectangle {
                    color: "transparent"
                }
                enabled: currentSongIndex < audioListModel.length - 1
                Image {
                    id: nextButton
                    source: "qrc:/assets/Images/Next.svg"
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                }
                onClicked: {
                    console.log("Next button clicked...");
                    if (currentSongIndex < audioListModel.length - 1) {
                        currentSongIndex++;
                        playCurrentItem();
                    }
                }
            }
        }
    }


    Rectangle {
        id: weatherRectangle
        anchors.left: musicRectangle.right
        anchors.leftMargin: 10
        width: (parent.width / 4) - 10
        height: cardHeight
        color: "transparent"
        radius: 20
        Rectangle {
            id: weatherRectangleShadow
            anchors.fill: weatherRectangle
            gradient: Gradient{
                GradientStop { position: 0.01; color: themeColor }
                GradientStop { position: 1.0; color: "#000" }
            }
            opacity: cardBackgroundOpacity
            radius: 20
        }
        Item {
            id: window
            width: parent.width
            height: parent.height
            state: "loading"
            states: [
                State {
                    name: "loading"
                    PropertyChanges { target: weatherMain; opacity: 0 }
                    PropertyChanges { target: wait; opacity: 1 }
                },
                State {
                    name: "ready"
                    PropertyChanges { target: weatherMain; opacity: 1 }
                    PropertyChanges { target: wait; opacity: 0 }
                }
            ]
            AppModel {
                id: model
                onReadyChanged: {
                    if (model.ready)
                        window.state = "ready"
                    else
                        window.state = "loading"
                }
            }
            Item {
                id: wait
                anchors.fill: parent

                Text {
                    text: "Loading weather data..."
                    anchors.centerIn: parent
                    font.pointSize: 14
                    color: "#fff"
                }
            }

            Item {
                id: weatherMain
                anchors.fill: parent

                Column {
                    spacing: 3
                    height: parent.height * 0.8
                    width: parent.width * 0.8
                    anchors {
                        top: parent.top
                        topMargin: 20
                        left: parent.left
                        leftMargin: 15
                    }
                    Text {
                        text: model.weather.temperature
                        font.pointSize: 35
                        color: "#fff"
                    }
                    Text {
                        text: model.weather.weatherDescription
                        font.pointSize: 20
                        color: "#fff"
                    }
                    Text {
                        text: "Test"
                        font.pointSize: 16
                        color: "transparent"
                    }
                    Text {
                        text: "Wolfsburg"
                        font.pointSize: 16
                        color: "#fff"
                    }
                    Text {
                        text: model.weather.maxTemperature + "/ " + model.weather.minTemperature + " Feels like " + model.weather.feelsLikeTemperature
                        font.pointSize: 16
                        color: "#fff"
                    }
                }
                Item {
                    width: parent.width * 0.2
                    height: parent.height * 0.2
                    anchors {
                        right: parent.right
                        rightMargin: 40
                        top: parent.top
                        topMargin: 20
                    }
                    WeatherIcon {
                        weatherIcon: model.hasValidWeather ? model.weather.weatherIcon : "01d"
                        useServerIcon: false
                        width: 90
                        height: 75
                    }
                }
                Item {
                    width: parent.width
                    height: parent.height * 0.2
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 20
                        left: parent.left
                    }
                    Column {
                        id: humidityColumn
                        anchors {
                            left: parent.left
                            leftMargin: 30
                        }
                        spacing: 5
                        Text {
                            text: "Humidity"
                            font.pointSize: 13
                            color: "#fff"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: model.weather.humidity + "%"
                            font.pointSize: 13
                            color: "#fff"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column {
                        id: separatorColumn
                        anchors {
                            left: humidityColumn.right
                            leftMargin: 20
                        }
                        spacing: 0
                        Text {
                            text: "|"
                            color: "#fff"
                            lineHeight: 0.85
                        }
                        Text {
                            text: "|"
                            color: "#fff"
                            lineHeight: 0.85
                        }
                        Text {
                            text: "|"
                            color: "#fff"
                            lineHeight: 0.85
                        }
                    }

                    Column {
                        id: windColumn
                        anchors {
                            right: parent.right
                            rightMargin: 30
                        }
                        spacing: 5
                        Text {
                            text: "Wind"
                            font.pointSize: 13
                            color: "#fff"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            text: model.weather.windSpeed + "km/h"
                            font.pointSize: 13
                            color: "#fff"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: gearRectangle
        anchors.left: weatherRectangle.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: (parent.width / 4) - 10
        height: cardHeight
        color: "transparent"
        radius: 20
        Rectangle {
            id: gearRectangleShadow
            anchors.fill: gearRectangle
            gradient: Gradient{
                GradientStop { position: 0.01; color: themeColor }
                GradientStop { position: 1.0; color: "#000" }
            }
            opacity: cardBackgroundOpacity
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Gear Card Touched");
                    main.componentSource = "Gear.qml";
                }
            }
            radius: 20
        }
        Column {
            anchors.centerIn: parent
            spacing: 25
            Text {
                text: "P"
                color: "#fff"
                font.pointSize: socketClient.gear === "P" ? 52 : 30
                font.bold: socketClient.gear === "P"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Gear P Touched");
                        if(main.speed <= 0 && socketClient.gear !== "P") {
                            socketClient.setGear("P");
                        }
                    }
                }
            }
            Text {
                text: "R"
                color: "#fff"
                font.pointSize: socketClient.gear === "R" ? 52 : 30
                font.bold: socketClient.gear === "R"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Gear R Touched");
                        if(main.speed <= 0 && socketClient.gear !== "R") {
                            socketClient.setGear("R");
                        }
                    }
                }
            }
            Text {
                text: "N"
                color: "#fff"
                font.pointSize: socketClient.gear === "N" ? 52 : 30
                font.bold: socketClient.gear === "N"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Gear N Touched");
                        if(main.speed <= 0 && socketClient.gear !== "N") {
                            socketClient.setGear("N");
                        }
                    }
                }
            }
            Text {
                text: "D"
                color: "#fff"
                font.pointSize: socketClient.gear === "D" ? 52 : 30
                font.bold: socketClient.gear === "D"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Gear D Touched");
                        if(main.speed <= 0 && socketClient.gear !== "D") {
                            socketClient.setGear("D");
                        }
                    }
                }
            }
        }
    }


    // Horizontal Icon Row
    Row {
        id: iconHorizontalRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 100
        }
        spacing: 120
        Rectangle {
            width: 100
            height: width
            radius: 20
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                gradient: Gradient{
                    GradientStop { position: 0.01; color: "#000" }
                    GradientStop { position: 1.0; color: themeColor }
                }
                opacity: cardBackgroundOpacity
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Map Icon Touched");
                        main.componentSource = "Map.qml";
                    }
                }
                radius: 20
            }
            Image {
                width: 70
                height: 70
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/assets/Images/Location.svg"
            }
        }
        Rectangle {
            width: 100
            height: width
            radius: 20
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                gradient: Gradient{
                    GradientStop { position: 0.01; color: "#000" }
                    GradientStop { position: 1.0; color: themeColor }
                }
                opacity: cardBackgroundOpacity
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Music Icon Touched");
                        main.componentSource = "AudioLayout2.qml";
                    }
                }
                radius: 20
            }
            Image {
                width: 80
                height: 80
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/assets/Images/Music.svg"
            }
        }
        Rectangle {
            width: 100
            height: width
            radius: 20
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                gradient: Gradient{
                    GradientStop { position: 0.01; color: "#000" }
                    GradientStop { position: 1.0; color: themeColor }
                }
                opacity: cardBackgroundOpacity
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(main.speed > 0) {
                            warningTextVisible = true;
                            warningTimer.running = true;
                            animation.start();
                            console.log("You cannot play video while driving");
                        } else {
                            console.log("Video Icon Touched");
                            main.componentSource = "VideoLayout.qml";
                        }
                    }
                }
                radius: 20
            }
            Image {
                width: 85
                height: 85
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/assets/Images/Video.svg"
            }
        }
        Rectangle {
            width: 100
            height: width
            radius: 20
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                gradient: Gradient{
                    GradientStop { position: 0.01; color: "#000" }
                    GradientStop { position: 1.0; color: themeColor }
                }
                opacity: cardBackgroundOpacity
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Settings Icon Touched");
                        main.componentSource = "Settings.qml";
                    }
                }
                radius: 20
            }
            Image {
                width: 75
                height: 75
                anchors.centerIn: parent
                fillMode: Image.Stretch
                source: "qrc:/assets/Images/Settings.svg"
            }
        }
    }

    Rectangle {
        id: warningRectangle
        visible: warningTextVisible
        color: "#fff"
        anchors {
            top: iconHorizontalRow.bottom
            topMargin: 20
            right: parent.right
            rightMargin: 20
        }
        radius: 10
        height: 30
        // width: 320
        Text {
            anchors.centerIn: parent
            text: "You cannot play video while driving"
            font.pointSize: 12
            color: "#000"
        }
        Timer {
            id: warningTimer
            interval: 5000
            repeat: false
            running: false
            onTriggered: {
                warningTextVisible = false;
            }
        }
        NumberAnimation {
            id: animation
            target: warningRectangle
            property: "width"
            from: 0
            to: 300
            duration: 500
            easing.type: Easing.Linear
        }
    }

    property int cardHeight: 350;
    property var cardBackgroundOpacity: 0.8;
    property bool warningTextVisible: false;
}
