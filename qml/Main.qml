import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import CloudPane

Window {
    id: root

    width: 388
    height: appController.currentPage === "activity" ? 560 : 472
    visible: false
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    modality: Qt.NonModal
    title: "CloudPane Prototype"

    Component.onCompleted: appController.registerPopup(root)
    onActiveChanged: {
        if (!active && appController.popupVisible) {
            appController.hidePopup()
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: appController.hidePopup()
    }

    FrostedPanel {
        id: panel

        anchors.fill: parent
        anchors.margins: 12

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 18

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: 42
                    radius: 14
                    color: "#DDF4FF"
                    border.color: "#7BC9FF"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "CP"
                        color: "#1657C6"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: appController.accountName
                        color: "#1A2237"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }

                    Text {
                        text: appController.currentPage === "activity" ? "Sync Activity" : "Tray Showcase"
                        color: "#637087"
                        font.pixelSize: 11
                    }
                }

                Button {
                    id: modeButton

                    flat: true
                    background: Rectangle {
                        implicitWidth: 34
                        implicitHeight: 34
                        radius: 12
                        color: modeButton.down ? "#22FFFFFF" : "transparent"
                    }
                    contentItem: Text {
                        text: appController.currentPage === "activity" ? "H" : "S"
                        color: "#1A2237"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        if (appController.currentPage === "activity") {
                            appController.showHome()
                        } else {
                            appController.showActivity()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#24A0B3C8"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: appController.currentPage === "activity" ? 432 : 304

                Loader {
                    anchors.fill: parent
                    sourceComponent: appController.currentPage === "activity" ? activityView : homeView
                }
            }
        }
    }

    Component {
        id: homeView

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 94
                radius: 22
                color: "#B9FFFFFF"
                border.color: "#53FFFFFF"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: appController.showActivity()
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 16

                    Rectangle {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        radius: 22
                        color: "#E5FFF0"
                        border.color: "#89DCA9"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "OK"
                            color: "#16964A"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Text {
                            text: appController.statusTitle
                            color: "#162033"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }

                        Text {
                            text: appController.statusSubtitle
                            color: "#617089"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    Text {
                        Layout.preferredWidth: 14
                        Layout.preferredHeight: 14
                        text: ">"
                        color: "#1A2237"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: 0.6
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 84
                radius: 20
                color: "#8BFFFFFF"
                border.color: "#42FFFFFF"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 4

                    Text {
                        text: "Expand Team Capacity"
                        color: "#172133"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: "A showcase CTA slot for storage, upgrades, or cross-sell concepts."
                        color: "#627187"
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#24A0B3C8"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                Repeater {
                    model: appController.quickActionsModel

                    QuickActionButton {
                        Layout.fillWidth: true
                        label: model.label
                        iconSource: model.iconName
                        onClicked: appController.triggerAction(model.id)
                    }
                }
            }
        }
    }

    Component {
        id: activityView

        ColumnLayout {
            anchors.fill: parent
            spacing: 14

            Button {
                flat: true
                leftPadding: 0
                contentItem: RowLayout {
                    spacing: 8

                    Text {
                        text: "<"
                        color: "#1D2940"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }

                    Text {
                        text: "Back to overview"
                        color: "#1D2940"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                    }
                }
                onClicked: appController.showHome()
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 82
                radius: 22
                color: "#B6FFFFFF"
                border.color: "#50FFFFFF"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    Rectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42
                        radius: 21
                        color: "#E9F4FF"
                        border.color: "#8AC5FF"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "S"
                            color: "#2F88FF"
                            font.pixelSize: 15
                            font.weight: Font.Bold
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: appController.statusTitle
                            color: "#172033"
                            font.pixelSize: 17
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: appController.statusSubtitle
                            color: "#607188"
                            font.pixelSize: 12
                        }
                    }
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 10
                model: appController.syncActivityModel
                boundsBehavior: Flickable.StopAtBounds

                delegate: SyncRow {
                    width: ListView.view.width
                    title: model.title
                    subtitle: model.subtitle
                    statusText: model.statusText
                    iconSource: model.iconName
                    progress: model.progress
                    state: model.state
                }
            }
        }
    }
}
