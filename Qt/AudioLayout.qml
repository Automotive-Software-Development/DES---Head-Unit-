import QtQuick 2.15
import QtMultimedia 5.15
import QtQml.Models 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15

Item {
    id: audioLayout
    width: parent.width
    height: parent.height

    Back {
        id: audioLayoutForBack
        width: parent.width
    }

    Item {
        id: loopItemForAudio
        anchors.top: audioLayoutForBack.top
        anchors.topMargin: 40
        anchors.left: audioLayoutForBack.left
        width: parent.width * 0.4
        height: parent.height - audioLayoutForBack.height

        FolderListModel {
            id: folderModel
            folder: "file:///home/charmi/Music" // Specify the path to your pendrive folder
            nameFilters: ["*.mp3"]
            showDirs: false
            onStatusChanged: {
                if (status === FolderListModel.Ready) {
                    console.log(folderModel.count, status)
                    for (var i = 0; i < folderModel.count; i++) {
                        console.log(folderModel.get(i, "fileName"), "...", folderModel.get(i, "filePath"))
                        audioListModel.append({
                                                  "name": folderModel.get(i, "fileName").split(".")[0],
                                                  "url": "file://" + folderModel.get(i, "filePath"),
                                                  "logo": `${folderModel.folder}/Images/${folderModel.get(i, "fileName").split(".")[0]}.jpg`
                                              });
                    }
                }
            }
        }

        ScrollView {
            id: scrollView
            width: parent.width
            height: parent.height
            ListView {
                id: listView
                width: scrollView.width
                height: scrollView.height
                model: ListModel {
                    id: audioListModel
                }
                delegate: Rectangle {
                    width: parent.width
                    height: 70
                    color: "transparent"
                    border.color: "#fff"

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        text: model.name
                        color: "#fff"
                        font.pointSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Play the selected audio file
                            audioSelected = true;
                            mediaPlayer.source = model.url;
                            mediaPlayer.play();
                            listView.currentIndex = index;
                            currentLogo = model.logo;
                            mediaPlayer.durationChanged.connect(function() {
                                console.log("Duration:", formatDuration(mediaPlayer.duration));
                            });
                        }
                    }
                }

            }
        }
    }

    MediaPlayer {
        id: mediaPlayer
        volume: 1.0 // Initial volume
        onDurationChanged: {
            if (mediaPlayer.duration > 0) {
                // Start the slider update timer when the duration becomes available
                sliderUpdateTimer.start();
            }
        }
        onPositionChanged: {
            if (mediaPlayer.duration > 0) {
                control.value = mediaPlayer.position / mediaPlayer.duration;
                elapsedTime = formatDuration(mediaPlayer.position);
            }
        }
        onErrorChanged: {
            // Debugging: Check if there's any error
            if (mediaPlayer.error !== MediaPlayer.NoError) {
                console.error("MediaPlayer Error:", mediaPlayer.errorString);
            }
        }
    }

    Rectangle {
        id: verticalSeparator
        color: "#fff"
        height: parent.height
        width: 1
        anchors.top: audioLayoutForBack.top
        anchors.topMargin: 40
        anchors.left: loopItemForAudio.right
    }

    /////////////////////////////////////////////////////////////////////////////////

    Item {
        height: parent.height - audioLayoutForBack.height
        width: parent.width - loopItemForAudio.width
        anchors.top: audioLayoutForBack.top
        anchors.topMargin: 40 // need to check
        anchors.left: verticalSeparator.right

        Text {
            visible: !audioSelected
            id: noAudioSelected
            text: "Please select an audio to play!"
            font.pointSize: 16
            color: "#fff"
            anchors.centerIn: parent
        }

        Rectangle {
            visible: audioSelected
            id: audioLogoInner
            height: 250
            width: 250
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            // radius: 125
            color: "transparent"
            border.color: "#fff"
            Image {
                id: audioLogo
                source: currentLogo
                anchors.fill: parent
                fillMode: Image.Stretch
            }
        }
        Rectangle {
            visible: audioSelected
            id: audioLogoOuter
            height: 310
            width: 310
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 70
            radius: 10
            color: "transparent"
            border.color: "#fff"
            border.width: 15
        }

        Rectangle {
            visible: audioSelected
            id: leftLine
            color: "#fff"
            height: 1
            anchors.left: parent.left
            anchors.right: audioLogoOuter.left
            anchors.top: parent.top
            anchors.topMargin: 50 + 175 // this should be the same as audioLogoOuter's topMargin + audioLogoOuter's radius
            width: audioLogoOuter.left - parent.left
        }

        Rectangle {
            visible: audioSelected
            id: righttLine
            color: "#fff"
            height: 1
            anchors.left: audioLogoOuter.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 50 + 175 // this should be the same as audioLogoOuter's topMargin + audioLogoOuter's radius
            width: parent.right - audioLogoOuter.right
        }

        Timer {
            id: sliderUpdateTimer
            interval: 1000 // Update every second
            running: mediaPlayer.playbackState === MediaPlayer.PlayingState // Only update when the media is playing

            onTriggered: {
                if (mediaPlayer.duration > 0) {
                    console.log("Started...")
                    control.value = mediaPlayer.position / mediaPlayer.duration;
                }
            }
        }

        Text {
            visible: audioSelected
            id: audioDuration
            text: mediaPlayer.duration > 0 ? elapsedTime : ''
            font.pointSize: 12
            color: "#fff"
            anchors.top: audioLogoOuter.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        Slider {
            visible: audioSelected
            id: control
            value: 0.0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: audioLogoOuter.bottom
            anchors.left: audioDuration.right
            anchors.leftMargin: 10
            width: 500

            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: control.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    color: "gray"
                    radius: 2
                }
            }

            handle: Rectangle {
                x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
                color: control.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            onValueChanged: {
                // Calculate the position in milliseconds based on the slider's value
                var newPosition = control.value * mediaPlayer.duration;

                // Seek to the new position
                mediaPlayer.seek(newPosition);
            }
        }

        Text {
            visible: audioSelected
            id: audioDurationTotal
            text: mediaPlayer.duration > 0 ? formatDuration(mediaPlayer.duration) : ''
            font.pointSize: 12
            color: "#fff"
            anchors.top: audioLogoOuter.bottom
            anchors.topMargin: 5
            anchors.left: control.right
            anchors.leftMargin: 10
        }

        Button {
            id: previousAudio
            visible: audioSelected
            height: control.height
            width: 30
            anchors.right: playOrPauseButton.left
            anchors.rightMargin: 3
            anchors.top: control.bottom
            anchors.topMargin: 8
            background: Rectangle {
                color: "transparent"
            }
            enabled: listView.currentIndex > 0
            Image {
                id: previousButton
                source: "qrc:/assets/Images/Previous.svg"
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
            onClicked: {
                console.log("Something", listView[listView.currentIndex])
                if (listView.currentIndex > 0) {
                    console.log(listView);
                    listView.currentIndex--;
                    playCurrentItem();
                }
            }
        }

        Button {
            id: playOrPauseButton
            visible: audioSelected
            height: control.height
            width: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: control.bottom
            anchors.topMargin: 8
            background: Rectangle {
                color: "transparent"
            }

            Image {
                id: playOrPause
                source: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/assets/Images/Pause.svg" : "qrc:/assets/Images/Play.svg"
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
            onClicked: {
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause();
                } else {
                    mediaPlayer.play();
                }
            }
        }

        Button {
            id: nextAudio
            visible: audioSelected
            height: control.height
            width: 30
            anchors.left: playOrPauseButton.right
            anchors.leftMargin: 3
            anchors.top: control.bottom
            anchors.topMargin: 8
            background: Rectangle {
                color: "transparent"
            }
            enabled: listView.currentIndex < audioListModel.count - 1
            Image {
                id: nextButton
                source: "qrc:/assets/Images/Next.svg"
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
            onClicked: {
                if (listView.currentIndex < audioListModel.count - 1) {
                    listView.currentIndex++;
                    playCurrentItem();
                }
            }
        }

        Image {
            visible: audioSelected
            id: volumeUp
            source: "qrc:/assets/Images/Volume_Up.svg"
            anchors.top: control.bottom
            anchors.topMargin: 12
            anchors.right: control.right
            width: 25
            height: 25
            MouseArea {
                id: volumeMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    volumeControl.visible = !volumeControl.visible;
                }
            }
        }
        Slider {
            visible: false
            id: volumeControl
            value: mediaPlayer.volume // Initial value
            width: 150
            anchors.top: control.bottom
            anchors.topMargin: 10
            anchors.right: volumeUp.left
            // Slider background and handle properties...
            background: Rectangle {
                x: volumeControl.leftPadding
                y: volumeControl.topPadding + volumeControl.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 2
                width: volumeControl.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"
                Rectangle {
                    width: volumeControl.visualPosition * parent.width
                    height: parent.height
                    color: "gray"
                    radius: 2
                }
            }
            handle: Rectangle {
                x: volumeControl.leftPadding + volumeControl.visualPosition * (volumeControl.availableWidth - width)
                y: volumeControl.topPadding + volumeControl.availableHeight / 2 - height / 2
                implicitWidth: 16
                implicitHeight: 16
                radius: 8
                color: volumeControl.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }
            onValueChanged: {
                // Set the volume of the media player
                mediaPlayer.volume = volumeControl.value;
            }
        }

    }


    /////////////////////////////////////////////////////////////////////////////////

    property bool audioSelected: false
    property bool audioListModelPopulated: false
    property string elapsedTime: '0:00'
    property string currentLogo: ""

    function formatDuration(duration) {
        var minutes = Math.floor(duration / 60000);
        var seconds = Math.floor((duration % 60000) / 1000);
        seconds = seconds < 10 ? "0" + seconds : seconds;
        return minutes + ':' + seconds;
    }

    function playCurrentItem() {
        var model = audioListModel.get(listView.currentIndex);
        mediaPlayer.source = model.url;
        currentLogo = model.logo;
        mediaPlayer.play();
    }
}

