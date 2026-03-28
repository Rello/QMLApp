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
        color: root.down ? "#16000000" : root.hovered ? "#0C000000" : "transparent"
        border.width: 0
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
                color: "#3A4557"
            }

            Rectangle {
                anchors.centerIn: parent
                width: 2
                height: 12
                radius: 1
                color: "#3A4557"
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
                color: "transparent"
                border.color: "#3A4557"
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
