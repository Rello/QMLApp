import QtQuick

Item {
    id: root

    default property alias contentData: contentItem.data

    Rectangle {
        anchors.fill: parent
        radius: 30
        color: "#D4F7FBFF"
        border.color: "#76FFFFFF"
        border.width: 1
    }

    Rectangle {
        width: 220
        height: 220
        x: -56
        y: 120
        radius: 110
        color: "#40FF9A8A"
    }

    Rectangle {
        width: 210
        height: 210
        x: parent.width - 180
        y: 22
        radius: 105
        color: "#4082D4FF"
    }

    Rectangle {
        width: 190
        height: 190
        x: 94
        y: parent.height - 148
        radius: 95
        color: "#33FFD68B"
    }

    Rectangle {
        anchors.fill: parent
        radius: 30
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#D9FFFFFF" }
            GradientStop { position: 0.45; color: "#BEEFFFFF" }
            GradientStop { position: 1.0; color: "#CCF8FBFF" }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 30
        color: "transparent"
        border.color: "#4EFFFFFF"
        border.width: 1
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}

