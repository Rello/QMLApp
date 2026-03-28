import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: root

    required property string label
    required property string iconSource

    flat: true
    padding: 0
    hoverEnabled: true

    ToolTip.visible: hovered
    ToolTip.text: label

    background: Rectangle {
        implicitWidth: 28
        implicitHeight: 28
        radius: 8
        color: root.down ? "#32E7F1FA" : root.hovered ? "#24E7F1FA" : "#18FFFFFF"
        border.color: root.hovered || root.down ? "#55A4B6C9" : "#34A4B6C9"
        border.width: 1
    }

    contentItem: Item {
        implicitWidth: 18
        implicitHeight: 18

        Image {
            anchors.centerIn: parent
            width: 16
            height: 16
            source: root.iconSource
            sourceSize.width: 16
            sourceSize.height: 16
            fillMode: Image.PreserveAspectFit
        }
    }
}
