pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects

import "Components"

Pane {
    id: root

    contentWidth: config.intValue("ScreenWidth") ?? Screen.width
    contentHeight: config.intValue("ScreenHeight") ?? Screen.height
    padding: config.intValue("ScreenPadding")

    LayoutMirroring.enabled: config.boolValue("MirroredLayout")
    LayoutMirroring.childrenInherit: true

    Clock {
        id: clock
        anchors {
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 100
            rightMargin: 100
        }
        z: 5
    }

    Item {
        id: content
        anchors.fill: parent
        visible: true

        Background {
            anchors.fill: parent
        }

        Item {
            id: loginFormContainer
            width: config.intValue("LoginFormWidth")

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 50
                topMargin: 50
                leftMargin: -1 * loginFormBackground.border.width
            }

            Rectangle {
                id: loginFormBackground
                anchors.fill: parent
                visible: false

                color: config.stringValue("LoginFormBackgroundColor")
                border.color: config.stringValue("LoginFormBorderColor")
                border.width: config.intValue("LoginFormBorderWidth")

                topRightRadius: config.intValue("LoginFormBorderRadius")
                bottomRightRadius: config.intValue("LoginFormBorderRadius")
            }

            MultiEffect {
                anchors.fill: loginFormBackground
                source: loginFormBackground
                shadowEnabled: true
                shadowBlur: 1
                shadowColor: "black"
                shadowVerticalOffset: 5
                shadowHorizontalOffset: 5
            }

            LoginForm {
                id: loginForm
                anchors.fill: parent
                opacity: 1.0

                onAvatarClicked: function () {
                    userSelectorPopup.open();
                }
                onPowerOffClicked: function () {
                    root.launchPopup(root.getConfirmationMessage("shutdown the system"), sddm.powerOff);
                }
                onRebootClicked: function () {
                    root.launchPopup(root.getConfirmationMessage("reboot the system"), sddm.reboot);
                }
                onSuspendClicked: function () {
                    root.launchPopup(root.getConfirmationMessage("suspend the system"), sddm.suspend);
                }
                onHibernateClicked: function () {
                    root.launchPopup(root.getConfirmationMessage("hibernate the system"), sddm.hibernate);
                }
            }
        }
    }

    Popup {
        id: userSelectorPopup
        modal: false
        focus: true
        anchors.centerIn: parent

        background: null
        padding: 0

        enter: Transition {
            NumberAnimation {
                property: "scale"
                from: 0.7
                to: 1.0
                duration: 300
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.OutBack
            }
        }

        UserSelector {
            id: userSelector
            anchors.centerIn: parent

            Rectangle {
                id: userSelectorBackground
                visible: false

                anchors.fill: parent
                anchors.margins: -border.width

                color: config.stringValue("UserSelectorBackgroundColor")

                border.color: config.stringValue("UserSelectorBorderColor")
                border.width: config.intValue("UserSelectorBorderWidth")
                radius: config.intValue("UserSelectorBorderRadius")
            }

            MultiEffect {
                anchors.fill: userSelectorBackground
                source: userSelectorBackground
                shadowEnabled: true
                shadowBlur: 1
                shadowColor: "black"
                shadowVerticalOffset: 5
                shadowHorizontalOffset: 5
            }

            onSelected: function (username, icon) {
                root.setActiveUser(username, icon);
                userSelectorPopup.close();
            }
        }
    }

    ConfirmationPopup {
        id: confirmationPopup
        anchors.centerIn: parent
    }

    Component {
        id: helperDelegate

        Item {
            required property string name
            required property var icon
            required property var index

            Component.onCompleted: function () {
                if (index == userModel.lastIndex || index === 0) {
                    root.setActiveUser(name, icon);
                }
            }
        }
    }

    Repeater {
        model: userModel
        delegate: helperDelegate
    }

    function setActiveUser(username, icon) {
        loginForm.username = username;
        loginForm.avatarIcon = icon;
    }

    function launchPopup(message, acceptedFunc) {
        confirmationPopup.message = message;
        confirmationPopup.acceptCallback = acceptedFunc;
        confirmationPopup.open();
    }

    function getConfirmationMessage(actionName) {
        return "Are you sure you want to " + actionName + "?";
    }

    Component.onCompleted: function () {
        Qt.callLater(() => loginForm.forceActiveFocus());
    }
}
