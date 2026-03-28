import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import CloudPane

Window {
    id: root

    readonly property bool activityPage: appController.currentPage === "activity"
    width: activityPage ? 372 : 286
    height: activityPage ? 488 : 188
    visible: false
    color: "#FFFFFFFF"
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
        panelRadius: activityPage ? 22 : 16
        baseColor: activityPage ? "#F4F7FBF4" : "#E8F4FAFF"
        baseBorderColor: "#FFFFFFFF"
        overlayStartColor: activityPage ? "#FFFFFFFF" : "#F3FFFFFF"
        overlayMidColor: activityPage ? "#F8FBFF" : "#EAF7FBFF"
        overlayEndColor: activityPage ? "#EEF3F9" : "#E1F2F8FF"
        highlightBorderColor: "#FFFFFFFF"

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
                color: activityPage ? "#D4DEE9" : "#24A0B3C8"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: activityPage ? 386 : 112

                Loader {
                    anchors.fill: parent
                    sourceComponent: activityPage ? activityView : homeView
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
                        text: "cloud.nextcloud.com"
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
                        text: "localhost:3032"
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

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                spacing: 10

                Item {
                    Layout.fillWidth: true
                }

                QuickActionButton {
                    label: "Add"
                    iconName: "add"
                    onClicked: appController.triggerAction("add")
                }

                QuickActionButton {
                    label: "More"
                    iconName: "more"
                    onClicked: appController.triggerAction("more")
                }

                QuickActionButton {
                    label: "Settings"
                    iconName: "settings"
                    onClicked: appController.triggerAction("settings")
                }
            }
        }
    }

    Component {
        id: activityView

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Button {
                flat: true
                leftPadding: 0
                contentItem: RowLayout {
                    spacing: 8

                    Text {
                        text: "<"
                        color: "#22324D"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }

                    Text {
                        text: "Back to overview"
                        color: "#22324D"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                    }
                }
                onClicked: appController.showHome()
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 46

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Rectangle {
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignTop
                        radius: 14
                        color: "#E4EEFB"
                        border.color: "#B5CBEC"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "S"
                            color: "#2F88FF"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            text: appController.statusTitle
                            color: "#172033"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: appController.statusSubtitle
                            color: "#607188"
                            font.pixelSize: 10
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#D4DEE9"
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 0
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
