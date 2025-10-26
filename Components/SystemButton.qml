import QtQuick
import QtQuick.Controls

RoundButton {
    id: root
    width: config.intValue("SystemButtonWidth")
    height: config.intValue("SystemButtonHeight")
    radius: config.intValue("SystemButtonBorderRadius")

    readonly property int iconPadding: config.intValue("SystemButtonPadding")

    function getBackgroundColor() {
        if (down)
            return config.stringValue("SystemButtonClickedBackgroundColor");
        if (hoverHandler.hovered)
            return config.stringValue("SystemButtonHoveredBackgroundColor");
        return config.stringValue("SystemButtonBackgroundColor");
    }

    background: Rectangle {
        id: background
        anchors.fill: parent
        radius: root.radius

        color: root.getBackgroundColor()

        Behavior on color {
            ColorAnimation {
                duration: 75
            }
        }
    }

    icon.width: width - iconPadding
    icon.height: height - iconPadding
    icon.color: config.stringValue("SystemButtonIconColor")

    display: RoundButton.IconOnly

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.AllDevices
        cursorShape: Qt.PointingHandCursor
    }
}
