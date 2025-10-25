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
    property url rightIcon: ""

    property alias text: textInput.text
    property alias echoMode: textInput.echoMode
    property alias placeholderText: placeholderText.text
    property alias textFocus: textInput.focus

    signal accepted
    signal editingFinished
    signal textEdited

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
                anchors.fill: parent
                anchors {
                    topMargin: config.intValue("InputFieldVerticalPadding")
                    bottomMargin: config.intValue("InputFieldVerticalPadding")
                    leftMargin: config.intValue("InputFieldHorizontalPadding")
                    rightMargin: config.intValue("InputFieldHorizontalPadding")
                }
                spacing: 8

                Loader {
                    active: root.leftIcon !== ""
                    sourceComponent: Image {
                        id: leftIcon
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        source: root.leftIcon
                        fillMode: Image.PreserveAspectCrop
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
                    active: root.rightIcon !== ""
                    sourceComponent: Image {
                        id: rightIcon
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        source: root.rightIcon
                        fillMode: Image.PreserveAspectCrop
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
