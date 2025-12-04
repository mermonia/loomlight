pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root
    anchors.centerIn: parent
    z: 1

    width: config.intValue("UserSelectorWidth")
    height: config.intValue("UserSelectorHeight")

    signal selected(string name, var icon)

    Component {
        id: entryDelegate

        Item {
            id: entryWrapper

            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            required property string name
            required property url icon
            required property int index

            Rectangle {
                id: background

                color: config.stringValue("UserSelectorEntryBackgroundColor")

                border.width: config.intValue("UserSelectorEntryBorderWidth")
                border.color: config.stringValue("UserSelectorEntryBorderColor")
                radius: config.intValue("UserSelectorEntryBorderRadius")

                anchors {
                    fill: parent
                    centerIn: parent
                    margins: config.intValue("UserSelectorSpacing")
                }
                Row {
                    anchors {
                        fill: parent
                        centerIn: parent
                        margins: config.intValue("UserSelectorEntryPadding")
                    }

                    spacing: config.intValue("UserSelectorEntrySpacing")

                    CircleCroppedImage {
                        anchors.verticalCenter: parent.verticalCenter
                        source: entryWrapper.icon
                        fillMode: Image.PreserveAspectCrop
                        diameter: config.intValue("UserSelectorAvatarDiameter")

                        backgroundColor: config.stringValue("UserSelectorAvatarBackgroundColor")

                        border.width: config.intValue("UserSelectorAvatarBorderWidth")
                        border.color: config.stringValue("UserSelectorAvatarBorderColor")
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: entryWrapper.name

                        font.family: config.stringValue("UserSelectorFontFamily")
                        font.pointSize: config.intValue("UserSelectorFontSize")
                        font.bold: true
                        color: config.stringValue("UserSelectorFontColor")
                    }

                    HoverHandler {
                        id: hoverHandler
                        acceptedDevices: PointerDevice.AllDevices
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        id: tapHandler
                        acceptedDevices: PointerDevice.AllDevices
                        gesturePolicy: TapHandler.ReleaseWithinBounds
                        longPressThreshold: 0.5
                        onTapped: function () {
                            root.selected(entryWrapper.name, entryWrapper.icon);
                        }
                    }
                }
            }
        }
    }

    GridView {
        id: userList
        anchors.fill: parent
        clip: true

        cellWidth: width / config.intValue("UserSelectorNumberItemsRow")
        cellHeight: height / config.intValue("UserSelectorNumberItemsColumn")

        model: userModel
        delegate: entryDelegate
        z: 1
    }
}
