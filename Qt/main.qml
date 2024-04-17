import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Qt.labs.folderlistmodel 2.15

Window {
    id: main
    width: 1024
    height: 600
    visible: true
    title: qsTr("Head Unit")

    Rectangle {
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "black"

        Loader {
            id: dynamicLayoutLoader
            anchors.fill: parent
            source: componentSource
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
                    sliderValue = mediaPlayer.position / mediaPlayer.duration;
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

        Timer {
            id: sliderUpdateTimer
            interval: 1000 // Update every second
            running: mediaPlayer.playbackState === MediaPlayer.PlayingState // Only update when the media is playing

            onTriggered: {
                if (mediaPlayer.duration > 0) {
                    sliderValue = mediaPlayer.position / mediaPlayer.duration;
                }
            }
        }

        FolderListModel {
            id: folderModel
            folder: "file:///home/charmi/Music" // Specify the path to your pendrive folder
            nameFilters: ["*.mp3"]
            showDirs: false
            onStatusChanged: {
                if (status === FolderListModel.Ready) {
                    for (var i = 0; i < folderModel.count; i++) {
                        audioListModel.push({
                                                "name": folderModel.get(i, "fileName").split(".")[0],
                                                "url": "file://" + folderModel.get(i, "filePath"),
                                                "logo": `${folderModel.folder}/Images/${folderModel.get(i, "fileName").split(".")[0]}.jpg`
                                            });
                    }
                }
            }
        }
    }

    function formatDuration(duration) {
        var minutes = Math.floor(duration / 60000);
        var seconds = Math.floor((duration % 60000) / 1000);
        seconds = seconds < 10 ? "0" + seconds : seconds;
        return minutes + ':' + seconds;
    }

    function playCurrentItem() {
        var model = audioListModel[currentSongIndex];
        mediaPlayer.source = model.url;
        currentLogo = model.logo;
        mediaPlayer.play();
    }

    property string componentSource: "Dashboard2.qml"
    property string currentTime: Head_Unit ? Head_Unit.currentTime : Qt.formatTime(new Date(),"hh:mm:ss");
    property string gearType: socketClient ? socketClient.gear : "No Gear Information"
    property var sliderValue: 0.0;
    property var elapsedTime: "";
    property var audioListModel: [];
    property string currentLogo: "";
    property int currentSongIndex: 0;
    property bool audioSelected: false;
    property string themeColor: "#00f";
    property double speed: parseFloat(socketClientForSpeed.rps)  * 3.14 * 2.5;


    Component.onCompleted: {
        socketClient.connectToServer("192.168.1.125", 3000); // Replace with your server address and port
    }
}
