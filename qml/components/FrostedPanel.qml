import QtQuick

Item {
    id: root

    default property alias contentData: contentItem.data
    property real panelRadius: 16
    property color baseColor: "#E8F4FAFF"
    property color baseBorderColor: "#DFFFFFFF"
    property color overlayStartColor: "#F3FFFFFF"
    property color overlayMidColor: "#EAF7FBFF"
    property color overlayEndColor: "#E1F2F8FF"
    property color highlightBorderColor: "#F2FFFFFF"

    Rectangle {
        anchors.fill: parent
        radius: root.panelRadius
        color: root.baseColor
        border.color: root.baseBorderColor
        border.width: 1
    }

    Rectangle {
        anchors.fill: parent
        radius: root.panelRadius
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.overlayStartColor }
            GradientStop { position: 0.55; color: root.overlayMidColor }
            GradientStop { position: 1.0; color: root.overlayEndColor }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.panelRadius
        color: "transparent"
        border.color: root.highlightBorderColor
        border.width: 1
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
