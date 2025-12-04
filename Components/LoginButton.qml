import QtQuick
import QtQuick.Controls

RoundButton {
    id: root

    implicitWidth: config.intValue("LoginButtonWidth")
    implicitHeight: config.intValue("LoginButtonHeight")

    radius: config.intValue("LoginButtonBorderRadius")

    font.family: config.stringValue("LoginButtonFontFamily")
    font.pointSize: config.stringValue("LoginButtonFontSize")
    palette.buttonText: config.stringValue("LoginButtonTextColor")

    text: "Login"

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.AllDevices
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        id: bg
        anchors.fill: root
        radius: root.radius
        color: config.stringValue("LoginButtonBackgroundColor")
        border.width: config.intValue("LoginButtonBorderWidth")
        border.color: config.stringValue("LoginButtonBorderColor")

        Behavior on border.color {
            ColorAnimation {
                duration: 100
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    states: [
        State {
            name: "clicked"
            when: root.down
            PropertyChanges {
                bg.color: config.stringValue("LoginButtonClickedBackgroundColor")
                bg.border.color: config.stringValue("LoginButtonClickedBorderColor")
            }
        },
        State {
            name: "hovered"
            when: hoverHandler.hovered
            PropertyChanges {
                bg.color: config.stringValue("LoginButtonHoveredBackgroundColor")
                bg.border.color: config.stringValue("LoginButtonHoveredBorderColor")
            }
        }
    ]
}
