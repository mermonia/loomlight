import QtQuick
import QtQuick.Controls

RoundButton {
    id: root
    width: config.intValue("SystemButtonWidth")
    height: config.intValue("SystemButtonHeight")
    radius: config.intValue("SystemButtonBorderRadius")

    property string backgroundColor: config.stringValue("SystemButtonBackgroundColor")
    property string hoveredColor: config.stringValue("SystemButtonHoveredBackgroundColor")
    property string clickedColor: config.stringValue("SystemButtonClickedBackgroundColor")

    readonly property int iconPadding: config.intValue("SystemButtonPadding")

    background: Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius

        color: root.backgroundColor

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

    states: [
        State {
            name: "clicked"
            when: root.down
            PropertyChanges {
                bg.color: root.clickedColor
            }
        },
        State {
            name: "hovered"
            when: hoverHandler.hovered || root.focus
            PropertyChanges {
                bg.color: root.hoveredColor
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "bg.color"
                duration: 40
            }
        }
    ]
}
