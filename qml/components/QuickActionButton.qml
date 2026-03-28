import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: root

    required property string label
    required property string iconName

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

        Loader {
            anchors.centerIn: parent
            sourceComponent: {
                if (root.iconName === "add") {
                    return addIcon
                }

                if (root.iconName === "more") {
                    return moreIcon
                }

                return settingsIcon
            }
        }
    }

    Component {
        id: addIcon

        Item {
            width: 16
            height: 16

            Rectangle {
                anchors.centerIn: parent
                width: 12
                height: 2
                radius: 1
                color: "#2E6DDA"
            }

            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: 12
                radius: 1
                color: "#2E6DDA"
            }
        }
    }

    Component {
        id: moreIcon

        Item {
            width: 16
            height: 16

            Row {
                anchors.centerIn: parent
                spacing: 3

                Repeater {
                    model: 3

                    Rectangle {
                        width: 3
                        height: 3
                        radius: 1.5
                        color: "#394557"
                    }
                }
            }
        }
    }

    Component {
        id: settingsIcon

        Item {
            width: 16
            height: 16

            Repeater {
                model: 8

                Item {
                    width: 16
                    height: 16
                    rotation: index * 45

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 0
                        width: 2
                        height: 4
                        radius: 1
                        color: "#3A4557"
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 10
                radius: 5
                color: "#F5F7FA"
                border.color: "#BFC8D4"
                border.width: 1
            }

            Rectangle {
                anchors.centerIn: parent
                width: 4
                height: 4
                radius: 2
                color: "#3A4557"
            }
        }
    }
}
