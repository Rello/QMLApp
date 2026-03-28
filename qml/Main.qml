import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import CloudPane

Window {
    id: root

    width: 286
    height: appController.currentPage === "activity" ? 500 : 164
    visible: false
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    modality: Qt.NonModal
    title: "CloudPane Prototype"
    readonly property int menuTitleFontSize: Math.max(14, Qt.application.font.pixelSize > 0 ? Qt.application.font.pixelSize + 1 : 14)
    readonly property int menuBodyFontSize: Math.max(13, Qt.application.font.pixelSize > 0 ? Qt.application.font.pixelSize + 1 : 13)
    readonly property int menuMetaFontSize: Math.max(12, Qt.application.font.pixelSize > 0 ? Qt.application.font.pixelSize : 12)

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
        anchors.margins: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                spacing: 8

                Image {
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    source: "qrc:/qml/icons/app-cloud.svg"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    Layout.fillWidth: true
                    text: "Nextcloud Desktop Client"
                    color: "#1A2237"
                    font.family: Qt.application.font.family
                    font.pixelSize: root.menuTitleFontSize
                    font.weight: Font.Normal
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#24A0B3C8"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: appController.currentPage === "activity" ? 398 : 78

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
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30

                MouseArea {
                    anchors.fill: parent
                    onClicked: appController.showActivity()
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Image {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: "qrc:/qml/icons/status-check.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        Layout.fillWidth: true
                        text: appController.statusTitle
                        color: "#162033"
                        font.family: Qt.application.font.family
                        font.pixelSize: root.menuBodyFontSize
                        font.weight: Font.Normal
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 12
                        text: ">"
                        color: "#1A2237"
                        font.family: Qt.application.font.family
                        font.pixelSize: root.menuMetaFontSize
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        opacity: 0.6
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
                Layout.preferredHeight: 30

                RowLayout {
                    anchors.fill: parent
                    spacing: 8

                    Image {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: "qrc:/qml/icons/plus.svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        Layout.fillWidth: true
                        text: "Get More Storage"
                        color: "#172133"
                        font.family: Qt.application.font.family
                        font.pixelSize: root.menuBodyFontSize
                        font.weight: Font.Normal
                        elide: Text.ElideRight
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 12
                        text: ">"
                        color: "#1A2237"
                        font.family: Qt.application.font.family
                        font.pixelSize: root.menuMetaFontSize
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        opacity: 0.6
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
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 34
                spacing: 10

                Repeater {
                    model: appController.quickActionsModel

                    QuickActionButton {
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
