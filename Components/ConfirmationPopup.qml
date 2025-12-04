import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Popup {
    id: root

    property alias message: messageText.text
    property var acceptCallback: null

    property string fontFamily: config.stringValue("PopupFontFamily")
    property string fontPointSize: config.intValue("PopupFontSize")

    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            property: "scale"
            from: 0.7
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
        }
    }

    width: config.intValue("PopupWidth")
    height: config.intValue("PopupHeight")

    background: MultiEffect {
        source: background
        shadowEnabled: true
        shadowBlur: 1
        shadowColor: "black"
        shadowVerticalOffset: 5
        shadowHorizontalOffset: 5
    }

    Rectangle {
        id: background
        anchors.fill: parent
        visible: false

        color: config.stringValue("PopupBackgroundColor")

        border.width: config.stringValue("PopupBorderWidth")
        border.color: config.stringValue("PopupBorderColor")
        radius: config.intValue("PopupBorderRadius")
    }

    Text {
        id: messageText

        anchors {
            top: parent.top
            topMargin: 50
            right: parent.right
            left: parent.left
            rightMargin: 20
            leftMargin: 20
        }
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        text: root.message

        color: config.stringValue("PopupTextColor")

        font.family: root.fontFamily
        font.pointSize: root.fontPointSize
    }

    Row {
        id: buttons
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }

        spacing: 10

        property int buttonWidth: config.intValue("PopupButtonWidth")
        property int buttonHeight: config.intValue("PopupButtonHeight")

        property int fontPointSize: config.intValue("PopupButtonFontSize")

        Button {
            id: cancelButton
            width: buttons.buttonWidth
            height: buttons.buttonHeight

            font.family: root.fontFamily
            font.pointSize: buttons.fontPointSize
            palette.buttonText: config.stringValue("PopupButtonCancelTextColor")

            text: "Cancel"

            HoverHandler {
                id: cancelHover
                acceptedDevices: PointerDevice.AllDevices
                cursorShape: Qt.PointingHandCursor
            }

            states: [
                State {
                    when: cancelHover.hovered
                    name: "hovered"
                    PropertyChanges {
                        cancelButtonBg.color: config.stringValue("PopupButtonCancelHoveredBackgroundColor")
                    }
                }
            ]

            background: Rectangle {
                id: cancelButtonBg
                anchors.fill: parent

                color: config.stringValue("PopupButtonCancelBackgroundColor")

                border.width: config.intValue("PopupButtonBorderWidth")
                border.color: config.stringValue("PopupButtonCancelBorderColor")
                radius: config.intValue("PopupButtonBorderRadius")

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }

            onClicked: function () {
                root.close();
            }
        }

        Button {
            id: confirmButton
            width: buttons.buttonWidth
            height: buttons.buttonHeight

            font.family: root.fontFamily
            font.pointSize: buttons.fontPointSize
            palette.buttonText: config.stringValue("PopupButtonConfirmTextColor")

            text: "Confirm"

            HoverHandler {
                id: confirmHover
                acceptedDevices: PointerDevice.AllDevices
                cursorShape: Qt.PointingHandCursor
            }

            states: [
                State {
                    when: confirmHover.hovered
                    name: "hovered"
                    PropertyChanges {
                        confirmButtonBg.color: config.stringValue("PopupButtonConfirmHoveredBackgroundColor")
                    }
                }
            ]

            onClicked: function () {
                root.acceptCallback();
                root.close();
            }

            background: Rectangle {
                id: confirmButtonBg
                anchors.fill: parent

                color: config.stringValue("PopupButtonConfirmBackgroundColor")

                border.width: config.intValue("PopupButtonBorderWidth")
                border.color: config.stringValue("PopupButtonConfirmBorderColor")
                radius: config.intValue("PopupButtonBorderRadius")

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
        }
    }
}
