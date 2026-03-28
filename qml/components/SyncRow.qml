import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property string title
    required property string subtitle
    required property string statusText
    required property string iconSource
    required property real progress
    required property string state

    height: state === "syncing" ? 54 : 44

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        spacing: 10

        Item {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: root.iconSource === "W" ? "#E8EEFF" : root.iconSource === "X" ? "#E5F5EA" : "#F8E8E1"
                border.color: root.iconSource === "W" ? "#BCCBFF" : root.iconSource === "X" ? "#B9E2C3" : "#EDC1B0"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: root.iconSource
                    color: root.iconSource === "W" ? "#2F61D8" : root.iconSource === "X" ? "#1F8F4C" : "#D9542C"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                text: root.title
                color: "#172033"
                font.pixelSize: 12
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                visible: root.subtitle.length > 0
                text: root.subtitle + "  \u00b7  " + root.statusText
                color: "#617287"
                font.pixelSize: 10
                elide: Text.ElideRight
            }

            Item {
                visible: root.state === "syncing"
                Layout.fillWidth: true
                Layout.topMargin: 3
                Layout.preferredHeight: 3

                Rectangle {
                    anchors.fill: parent
                    radius: 2
                    color: "#D9E3EF"
                }

                Rectangle {
                    width: parent.width * Math.max(0.04, root.progress)
                    height: parent.height
                    radius: 2
                    color: "#318BFF"
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#DDE4EC"
    }
}
