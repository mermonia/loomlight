pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

FocusScope {
    id: root

    property alias labelText: label.text

    property var validator: undefined
    property bool hasError: false
    property alias errorMessage: errorText.text

    property url leftIcon: ""
    property url rightIcon: ""
    property bool isLeftIconConnected: false
    property bool isRightIconConnected: false

    property alias text: textInput.text
    property alias echoMode: textInput.echoMode
    property alias placeholderText: placeholderText.text
    property alias textFocus: textInput.focus

    signal accepted
    signal editingFinished
    signal textEdited

    signal leftIconClicked
    signal rightIconClicked

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

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        Text {
            id: label
            Layout.alignment: Qt.AlignLeft
            visible: config.boolValue("InputFieldHasLabel")
            color: config.stringValue("InputFieldLabelColor")
            font.pointSize: config.stringValue("InputFieldLabelFontSize")
        }

        Rectangle {
            id: background
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: config.intValue("InputFieldWidth")
            Layout.preferredHeight: config.intValue("InputFieldHeight")
            color: config.stringValue("InputFieldBackgroundColor")
            border.color: getBorderColor()
            border.width: config.intValue("InputFieldBorderWidth")
            radius: config.intValue("InputFieldBorderRadius")

            function getBorderColor() {
                if (root.hasError)
                    return config.stringValue("InputFieldErrorBorderColor");
                if (textInput.activeFocus)
                    return config.stringValue("InputFieldFocusedBorderColor");
                return config.stringValue("InputFieldBorderColor");
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }

            RowLayout {
                id: mainRow
                anchors.fill: parent
                anchors {
                    topMargin: config.intValue("InputFieldVerticalPadding")
                    bottomMargin: config.intValue("InputFieldVerticalPadding")
                    leftMargin: config.intValue("InputFieldHorizontalPadding")
                    rightMargin: config.intValue("InputFieldHorizontalPadding")
                }
                spacing: 8

                Loader {
                    Layout.fillHeight: true

                    active: root.leftIcon !== ""
                    sourceComponent: Button {
                        id: leftIconButton
                        property bool isConnected: root.isLeftIconConnected

                        height: parent.height
                        width: parent.width

                        icon.source: root.leftIcon
                        icon.color: {
                            if (isConnected && down)
                                return config.stringValue("InputFieldIconClickedColor");
                            if (isConnected && leftIconHoverHandler.hovered)
                                return config.stringValue("InputFieldIconHoveredColor");
                            return config.stringValue("InputFieldIconColor");
                        }
                        icon.width: config.intValue("InputFieldIconWidth")
                        icon.height: config.intValue("InputFieldIconHeight")

                        background: null
                        display: Button.IconOnly

                        HoverHandler {
                            id: leftIconHoverHandler
                            acceptedDevices: PointerDevice.AllDevices
                            cursorShape: Qt.PointingHandCursor
                        }

                        onClicked: root.leftIconClicked()
                    }
                }

                TextInput {
                    id: textInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 0
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
                        padding: 0
                        font.pointSize: textInput.font.pointSize
                        color: config.stringValue("InputFieldPlaceholderColor")
                        visible: textInput.text == ""
                        anchors.verticalCenter: textInput.verticalCenter
                    }
                }

                Loader {
                    Layout.fillHeight: true

                    active: root.rightIcon !== ""
                    sourceComponent: Button {
                        id: rightIconButton
                        property bool isConnected: root.isRightIconConnected

                        height: parent.height
                        width: parent.width

                        icon.source: root.rightIcon
                        icon.color: {
                            if (isConnected && down)
                                return config.stringValue("InputFieldIconClickedColor");
                            if (isConnected && rightIconHoverHandler.hovered)
                                return config.stringValue("InputFieldIconHoveredColor");
                            return config.stringValue("InputFieldIconColor");
                        }
                        icon.width: config.intValue("InputFieldIconWidth")
                        icon.height: config.intValue("InputFieldIconHeight")

                        background: null
                        display: Button.IconOnly

                        HoverHandler {
                            id: rightIconHoverHandler
                            acceptedDevices: PointerDevice.AllDevices
                            cursorShape: Qt.PointingHandCursor
                        }

                        onClicked: root.rightIconClicked()
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
