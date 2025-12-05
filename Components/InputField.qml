pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

FocusScope {
    id: root

    property alias labelText: label.text

    property var validator: undefined
    property bool hasError: false
    property alias errorMessage: errorText.text

    property url leftIcon: ""
    property bool isLeftIconConnected: false

    property alias text: textInput.text
    property alias echoMode: textInput.echoMode
    property alias placeholderText: placeholderText.text
    property alias textFocus: textInput.focus
    property alias font: textInput.font

    signal accepted
    signal editingFinished
    signal textEdited
    signal leftIconClicked

    onFocusChanged: function () {
        if (focus)
            textInput.forceActiveFocus();
    }

    implicitWidth: background.width
    implicitHeight: background.height + errorText.implicitHeight + column.spacing * 2

    Column {
        id: column
        spacing: 8
        anchors.centerIn: parent

        Text {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            visible: config.boolValue("InputFieldHasLabel")
            color: config.stringValue("InputFieldLabelColor")
            font.pointSize: config.intValue("InputFieldLabelFontSize")
            font.bold: true
        }

        Rectangle {
            id: background

            property string borderColor: config.stringValue("InputFieldBorderColor")
            property string errorBorderColor: config.stringValue("InputFieldErrorBorderColor")
            property string focusedBorderColor: config.stringValue("InputFieldFocusedBorderColor")

            property string bgColor: config.stringValue("InputFieldBackgroundColor")
            property string hoveredBgColor: config.stringValue("InputFieldHoveredBackgroundColor")
            property string focusedBgColor: config.stringValue("InputFieldFocusedBackgroundColor")

            width: config.intValue("InputFieldWidth")
            height: config.intValue("InputFieldHeight")

            color: bgColor

            border.width: config.intValue("InputFieldBorderWidth")
            border.color: borderColor
            radius: config.intValue("InputFieldBorderRadius")

            HoverHandler {
                id: hoverHandler
                acceptedDevices: PointerDevice.AllDevices
                cursorShape: Qt.IBeamCursor
            }
            states: [
                State {
                    name: "error"
                    when: root.hasError
                    PropertyChanges {
                        target: background
                        border.color: background.errorBorderColor
                    }
                },
                State {
                    name: "focused"
                    when: textInput.activeFocus
                    PropertyChanges {
                        target: background
                        border.color: background.focusedBorderColor
                    }
                    PropertyChanges {
                        target: background
                        color: background.focusedBgColor
                    }
                },
                State {
                    name: "hovered"
                    when: hoverHandler.hovered
                    PropertyChanges {
                        target: background
                        color: background.hoveredBgColor
                    }
                }
            ]

            transitions: [
                Transition {
                    ColorAnimation {
                        property: "color"
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }
            ]

            Item {
                id: inputWrapper

                property int vpad: config.intValue("InputFieldVerticalPadding")
                property int hpad: config.intValue("InputFieldHorizontalPadding")

                anchors {
                    fill: parent
                    topMargin: vpad
                    bottomMargin: vpad
                    leftMargin: hpad
                    rightMargin: hpad
                }

                Loader {
                    id: leftIconLoader

                    width: config.intValue("InputFieldIconWidth")
                    height: config.intValue("InputFieldIconHeight")

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: inputWrapper.left

                    active: root.leftIcon != ""
                    visible: active

                    sourceComponent: Button {
                        id: leftIconButton

                        anchors.fill: parent
                        anchors.centerIn: parent

                        property string iconColor: config.stringValue("InputFieldIconColor")
                        property string iconHoveredColor: config.stringValue("InputFieldIconHoveredColor")
                        property string iconClickedColor: config.stringValue("InputFieldIconClickedColor")
                        property bool isConnected: root.isLeftIconConnected

                        icon.source: root.leftIcon
                        icon.width: width
                        icon.height: height
                        icon.color: iconColor

                        background: null
                        display: Button.IconOnly

                        onClicked: root.leftIconClicked()

                        HoverHandler {
                            id: leftIconHoverHandler
                            acceptedDevices: PointerDevice.AllDevices
                            cursorShape: leftIconButton.isConnected ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }

                        states: [
                            State {
                                name: "clicked"
                                when: leftIconButton.isConnected && leftIconButton.down
                                PropertyChanges {
                                    target: leftIconButton
                                    icon.color: leftIconButton.iconClickedColor
                                }
                            },
                            State {
                                name: "hovered"
                                when: leftIconButton.isConnected && leftIconHoverHandler.hovered
                                PropertyChanges {
                                    target: leftIconButton
                                    icon.color: leftIconButton.iconHoveredColor
                                }
                            }
                        ]

                        Behavior on icon.color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }

                TextInput {
                    id: textInput

                    anchors {
                        fill: inputWrapper
                        rightMargin: leftIconLoader.active ? leftIconLoader.width : 0
                        leftMargin: leftIconLoader.active ? leftIconLoader.width : 0
                    }

                    color: config.stringValue("InputFieldTextColor")

                    font.pointSize: config.intValue("InputFieldTextFontSize")
                    font.bold: true

                    verticalAlignment: TextInput.AlignVCenter
                    horizontalAlignment: TextInput.AlignHCenter
                    selectByMouse: true
                    clip: true

                    onAccepted: root.accepted()
                    onEditingFinished: root.editingFinished()
                    onTextEdited: root.textEdited()

                    onTextChanged: scaleAnim.restart()

                    NumberAnimation {
                        id: scaleAnim
                        target: textInput
                        property: "scale"
                        from: 0.98
                        to: 1.0
                        duration: 100
                        easing.type: Easing.OutQuad
                    }

                    Text {
                        id: placeholderText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 2
                        visible: textInput.text === ""
                        font.pointSize: textInput.font.pointSize
                        color: config.stringValue("InputFieldPlaceholderColor")
                    }
                }
            }
        }

        Text {
            id: errorText
            anchors.horizontalCenter: parent.horizontalCenter
            color: config.stringValue("InputFieldErrorMessageColor")
            font.pointSize: config.intValue("InputFieldErrorMessageFontSize")
            font.bold: true
            visible: root.hasError
        }
    }

    function validate() {
        if (typeof validator !== "function")
            return true;
        const result = validator(textInput.text);
        if (result === true) {
            hasError = false;
            errorMessage = "";
            return true;
        }
        if (typeof result === "string") {
            hasError = true;
            errorMessage = result;
            return false;
        }
        console.warn("validator function returned an unexpected value");
        return false;
    }

    function triggerError(message) {
        hasError = true;
        errorMessage = message;
    }

    function clearError(message) {
        hasError = false;
        errorMessage = "";
    }
}
