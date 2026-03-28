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

    radius: 20
    height: state === "syncing" ? 112 : 94
    color: "#A8FFFFFF"
    border.color: "#42FFFFFF"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 14

        Rectangle {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            radius: 14
            color: root.iconSource === "W" ? "#E8EEFF" : root.iconSource === "X" ? "#E5F5EA" : "#F8E8E1"
            border.color: root.iconSource === "W" ? "#BCCBFF" : root.iconSource === "X" ? "#B9E2C3" : "#EDC1B0"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: root.iconSource
                color: root.iconSource === "W" ? "#2F61D8" : root.iconSource === "X" ? "#1F8F4C" : "#D9542C"
                font.pixelSize: 18
                font.weight: Font.Bold
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                text: root.title
                color: "#172033"
                font.pixelSize: 15
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                visible: root.subtitle.length > 0
                text: root.subtitle
                color: "#6A7991"
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Text {
                text: root.statusText
                color: "#5A6D87"
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            Item {
                visible: root.state === "syncing"
                Layout.fillWidth: true
                Layout.preferredHeight: 8

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: "#36AFC7E0"
                }

                Rectangle {
                    width: parent.width * Math.max(0.04, root.progress)
                    height: parent.height
                    radius: 4
                    color: "#318BFF"
                }
            }
        }
    }
}
