pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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

    signal accepted
    signal editingFinished
    signal textEdited
    signal leftIconClicked

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

    Column {
        spacing: 6
        anchors.fill: parent

        Text {
            id: label
            visible: config.boolValue("InputFieldHasLabel")
            color: config.stringValue("InputFieldLabelColor")
            font.pointSize: config.intValue("InputFieldLabelFontSize")
        }

        Rectangle {
            id: background

            property string borderColor: config.stringValue("InputFieldBorderColor")
            property string errorBorderColor: config.stringValue("InputFieldErrorBorderColor")
            property string focusedBorderColor: config.stringValue("InputFieldFocusedBorderColor")

            width: config.intValue("InputFieldWidth")
            height: config.intValue("InputFieldHeight")
            radius: config.intValue("InputFieldBorderRadius")

            color: config.stringValue("InputFieldBackgroundColor")
            border.width: config.intValue("InputFieldBorderWidth")
            border.color: borderColor

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
                }
            ]

            RowLayout {
                property int vpad: config.intValue("InputFieldVerticalPadding")
                property int hpad: config.intValue("InputFieldHorizontalPadding")

                anchors {
                    fill: parent
                    topMargin: vpad
                    bottomMargin: vpad
                    leftMargin: hpad
                    rightMargin: hpad
                }
                spacing: 8

                Loader {
                    active: root.leftIcon != ""
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    sourceComponent: Button {
                        id: leftIconButton

                        anchors.fill: parent

                        property string iconColor: config.stringValue("InputFieldIconColor")
                        property string iconHoveredColor: config.stringValue("InputFieldIconHoveredColor")
                        property string iconClickedColor: config.stringValue("InputFieldIconClickedColor")
                        property bool isConnected: root.isLeftIconConnected

                        icon.source: root.leftIcon
                        icon.width: config.intValue("InputFieldIconWidth")
                        icon.height: config.intValue("InputFieldIconHeight")
                        icon.color: iconColor

                        background: null
                        display: Button.IconOnly

                        onClicked: {
                            console.log(parent.parent.width, parent.parent.height);
                            console.log(width, height);
                            root.leftIconClicked();
                        }

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

                        transitions: [
                            Transition {
                                PropertyAnimation {
                                    properties: "leftIconButton.icon.color"
                                    duration: 40
                                }
                            }
                        ]
                    }
                }

                TextInput {
                    id: textInput

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: config.stringValue("InputFieldTextColor")
                    font.pointSize: config.intValue("InputFieldTextFontSize")
                    verticalAlignment: TextInput.AlignVCenter

                    selectByMouse: true
                    clip: true

                    onAccepted: root.accepted()
                    onEditingFinished: root.editingFinished()
                    onTextEdited: root.textEdited()

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
            color: config.stringValue("InputFieldErrorMessageColor")
            font.pointSize: config.intValue("InputFieldErrorMessageFontSize")
            visible: root.hasError
        }
    }
}
