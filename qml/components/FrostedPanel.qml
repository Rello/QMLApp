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
        anchors.fill: parent
        radius: 30
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#EBFFFFFF" }
            GradientStop { position: 0.55; color: "#DFF6FBFF" }
            GradientStop { position: 1.0; color: "#D5F0F9FF" }
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
