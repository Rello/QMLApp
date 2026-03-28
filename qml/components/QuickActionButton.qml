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
        implicitWidth: 38
        implicitHeight: 38
        radius: 11
        color: root.down ? "#2AFFFFFF" : root.hovered ? "#1EFFFFFF" : "transparent"
        border.color: root.hovered || root.down ? "#35A4B6C9" : "transparent"
        border.width: 1
    }

    contentItem: Item {
        implicitWidth: 38
        implicitHeight: 38

        Text {
            anchors.centerIn: parent
            text: root.iconSource
            color: "#182338"
            font.pixelSize: root.iconSource === "⋯" ? 18 : 15
            font.weight: Font.DemiBold
        }
    }
}
