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
        implicitWidth: 30
        implicitHeight: 30
        radius: 9
        color: root.down ? "#28E7F1FA" : root.hovered ? "#20E7F1FA" : "#12FFFFFF"
        border.color: root.hovered || root.down ? "#45A4B6C9" : "#22A4B6C9"
        border.width: 1
    }

    contentItem: Text {
        text: root.iconSource
        color: "#182338"
        font.pixelSize: root.iconSource === "⋯" ? 16 : 13
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
