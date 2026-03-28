import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property string title
    required property string subtitle
    required property string statusText
    required property string iconSource
    required property real progress
    required property string state

    radius: 18
    height: state === "syncing" ? 84 : 68
    color: state === "syncing" ? "#F6FBFFFF" : "#F8FAFDEB"
    border.color: state === "syncing" ? "#B9D4F7" : "#D8E1EC"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            radius: 12
            color: root.iconSource === "W" ? "#E8EEFF" : root.iconSource === "X" ? "#E5F5EA" : "#F8E8E1"
            border.color: root.iconSource === "W" ? "#BCCBFF" : root.iconSource === "X" ? "#B9E2C3" : "#EDC1B0"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: root.iconSource
                color: root.iconSource === "W" ? "#2F61D8" : root.iconSource === "X" ? "#1F8F4C" : "#D9542C"
                font.pixelSize: 15
                font.weight: Font.Bold
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                color: "#172033"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                visible: root.subtitle.length > 0
                text: root.subtitle
                color: "#6A7991"
                font.pixelSize: 10
                elide: Text.ElideRight
            }

            Text {
                text: root.statusText
                color: "#5A6D87"
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Item {
                visible: root.state === "syncing"
                Layout.fillWidth: true
                Layout.topMargin: 2
                Layout.preferredHeight: 6

                Rectangle {
                    anchors.fill: parent
                    radius: 3
                    color: "#D8E7F5"
                }

                Rectangle {
                    width: parent.width * Math.max(0.04, root.progress)
                    height: parent.height
                    radius: 3
                    color: "#318BFF"
                }
            }
        }
    }
}
