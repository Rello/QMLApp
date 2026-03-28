import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: root

    required property string label
    required property string iconSource

    flat: true
    padding: 0

    background: Rectangle {
        implicitWidth: 74
        implicitHeight: 74
        radius: 22
        color: root.down ? "#1EFFFFFF" : "#14FFFFFF"
        border.color: "#35FFFFFF"
        border.width: 1
    }

    contentItem: ColumnLayout {
        spacing: 6

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 10
            color: "#24FFFFFF"

            Text {
                anchors.centerIn: parent
                text: root.iconSource
                color: "#1B2942"
                font.pixelSize: root.iconSource.length > 1 ? 10 : 12
                font.weight: Font.Bold
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.label
            color: "#23314A"
            font.pixelSize: 11
            font.weight: Font.Medium
        }
    }
}
