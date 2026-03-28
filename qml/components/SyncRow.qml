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
            color: "#F4F7FB"
            border.color: "#D8E0EA"
            border.width: 1

            Image {
                anchors.centerIn: parent
                width: 26
                height: 26
                source: root.iconSource
                fillMode: Image.PreserveAspectFit
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

