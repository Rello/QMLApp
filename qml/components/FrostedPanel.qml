import QtQuick

Item {
    id: root

    default property alias contentData: contentItem.data

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#E8F4FAFF"
        border.color: "#76FFFFFF"
        border.width: 1
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#F3FFFFFF" }
            GradientStop { position: 0.55; color: "#EAF7FBFF" }
            GradientStop { position: 1.0; color: "#E1F2F8FF" }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "transparent"
        border.color: "#60D7E1EA"
        border.width: 1
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
