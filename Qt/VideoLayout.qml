import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15
import QtQml 2.15


Item {
    id: videoLayout
    width: parent.width
    height: parent.height

    Back {
        id: videoLayoutForBack
        width: parent.width
    }

    Item {
        id: loopItemForVideo
        anchors.top: videoLayoutForBack.top
        anchors.topMargin: 40
        anchors.left: videoLayoutForBack.left
        width: parent.width * 0.4
        height: parent.height - videoLayoutForBack.height

        FolderListModel {
            id: folderModel
            folder: "file:///home/charmi/Videos" // Specify the path to your pendrive folder
            nameFilters: ["*.mp4"]
            showDirs: false
            onStatusChanged: {
                if (status === FolderListModel.Ready) {
                    console.log(folderModel.count, status)
                    for (var i = 0; i < folderModel.count; i++) {
                        console.log(folderModel.get(i, "fileName"), "...", folderModel.get(i, "filePath"))
                        videoListModel.append({
                                                  "name": folderModel.get(i, "fileName"),
                                                  "url": "file://" + folderModel.get(i, "filePath"),
                                                  "selected": false
                                              });
                    }
                }
            }
        }

        ListView {
            id: listView
            width: parent.width
            height: parent.height
            model: ListModel {
                id: videoListModel
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
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        // Play the selected audio file
                        videoSelected = true;
                        mediaPlayer.source = model.url;
                        mediaPlayer.play();
                        mediaPlayer.durationChanged.connect(function() {
                            console.log("Duration:", formatDuration(mediaPlayer.duration));
                        });
                    }
                }
            }
        }
    }

    MediaPlayer {
        id: mediaPlayer
        volume: 1.0 // Initial volume
        autoPlay: true
        onDurationChanged: {
            if (mediaPlayer.duration > 0) {
                console.log("Duration:", formatDuration(mediaPlayer.duration));
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
        anchors.top: videoLayoutForBack.top
        anchors.topMargin: 40
        anchors.left: loopItemForVideo.right
    }

    /////////////////////////////////////////////////////////////////////////////////

    Item {
        height: parent.height - videoLayoutForBack.height
        width: parent.width - loopItemForVideo.width
        anchors.top: videoLayoutForBack.top
        anchors.topMargin: 40 // need to check
        anchors.left: verticalSeparator.right

        Text {
            visible: !videoSelected
            id: noVideoSelected
            text: "Please select a video to play!"
            font.pointSize: 16
            color: "#fff"
            anchors.centerIn: parent
        }

        Rectangle {
            visible: videoSelected
            id: videoLogoOuter
            height: parent.height
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 2
            // radius: 175
            color: "transparent"
            border.color: "#fff"
            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                source: mediaPlayer
                fillMode: VideoOutput.PreserveAspectCrop
            }
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

        Slider {
            visible: videoSelected
            id: control
            value: 0.0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: volumeControl.top
            width: 600

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

        Button {
            id: playOrPauseButton
            visible: videoSelected
            height: control.height
            width: 30
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45
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
            id: nextVideo
            visible: videoSelected
            height: control.height
            width: 30
            anchors.left: playOrPauseButton.right
            anchors.leftMargin: 3
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45
            background: Rectangle {
                color: "transparent"
            }
            enabled: listView.currentIndex < videoListModel.count - 1
            Image {
                id: nextButton
                source: "qrc:/assets/Images/Next.svg"
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
            }
            onClicked: {
                if (listView.currentIndex < videoListModel.count - 1) {
                    listView.currentIndex++;
                    playCurrentItem();
                }
            }
        }

        Text {
            visible: videoSelected
            id: videoDuration
            text: mediaPlayer.duration > 0 ? elapsedTime + "/" + formatDuration(mediaPlayer.duration) : elapsedTime + "/" + "0:00"
            font.pointSize: 12
            color: "#fff"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 51
            anchors.left: nextVideo.right
            anchors.leftMargin: 8
        }

        Image {
            visible: videoSelected
            id: volumeUp
            source: "qrc:/assets/Images/Volume_Up.svg"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 20
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 47
            anchors.right: volumeUp.left
            width: 150

            // Slider background and handle properties...
            background: Rectangle {
                x: volumeControl.leftPadding
                y: volumeControl.topPadding + volumeControl.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 3
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
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
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

    property bool videoSelected: false
    property bool videoListModelPopulated: false
    property string elapsedTime: '0:00'

    function formatDuration(duration) {
        var minutes = Math.floor(duration / 60000);
        var seconds = Math.floor((duration % 60000) / 1000);
        seconds = seconds < 10 ? "0"+seconds : seconds;
        return minutes + ':' + seconds;
    }

    function playCurrentItem() {
        var model = videoListModel.get(listView.currentIndex);
        mediaPlayer.source = model.url;
        mediaPlayer.play();
    }
}

