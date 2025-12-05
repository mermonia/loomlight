import QtQuick
import QtQuick.Layouts

FocusScope {
    id: root

    property alias avatarIcon: userAvatarButton.icon
    property alias username: userField.text

    property bool passwordHidden: true

    signal avatarClicked
    signal powerOffClicked
    signal rebootClicked
    signal suspendClicked
    signal hibernateClicked

    onFocusChanged: function () {
        userField.forceActiveFocus();
    }

    states: [
        State {
            name: "passwordHidden"
            when: root.passwordHidden
            PropertyChanges {
                passwordField.echoMode: TextInput.Password
                passwordField.font.bold: false
                passwordField.font.pointSize: 12
                passwordField.leftIcon: Qt.resolvedUrl("../Assets/not-visible.svg")
            }
        }
    ]

    ColumnLayout {
        id: formItems
        anchors.centerIn: parent

        spacing: 0

        UserAvatarButton {
            id: userAvatarButton
            diameter: 200

            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: 40
            Layout.topMargin: 140

            onClicked: root.avatarClicked()
        }

        InputField {
            id: userField
            Layout.alignment: Qt.AlignCenter
            leftIcon: Qt.resolvedUrl("../Assets/user.svg")

            onAccepted: function () {
                root.login();
            }

            focus: true
            KeyNavigation.tab: passwordField
        }

        InputField {
            id: passwordField
            Layout.alignment: Qt.AlignCenter
            leftIcon: Qt.resolvedUrl("../Assets/visible.svg")
            isLeftIconConnected: true
            onLeftIconClicked: function () {
                root.passwordHidden = !root.passwordHidden;
            }

            onAccepted: function () {
                root.login();
            }

            KeyNavigation.backtab: userField
            KeyNavigation.tab: loginButton
        }

        LoginButton {
            id: loginButton
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40

            onClicked: function () {
                root.login();
            }

            KeyNavigation.backtab: passwordField
            KeyNavigation.tab: systemButtons
        }

        Row {
            id: systemButtons
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 140
            Layout.bottomMargin: 40
            spacing: 4

            onFocusChanged: function () {
                if (systemButtons.focus) {
                    powerOffButton.forceActiveFocus();
                }
            }

            SystemButton {
                id: powerOffButton
                visible: !sddm.canPowerOff
                icon.source: Qt.resolvedUrl("../Assets/shutdown.svg")
                onClicked: root.powerOffClicked()

                focus: true
                KeyNavigation.backtab: loginButton
                KeyNavigation.tab: rebootButton
            }

            SystemButton {
                id: rebootButton
                visible: !sddm.canReboot
                icon.source: Qt.resolvedUrl("../Assets/reboot.svg")
                onClicked: root.rebootClicked()

                KeyNavigation.backtab: powerOffButton
                KeyNavigation.tab: suspendButton
            }

            SystemButton {
                id: suspendButton
                visible: !sddm.canSuspend
                icon.source: Qt.resolvedUrl("../Assets/suspend.svg")
                onClicked: root.suspendClicked()

                KeyNavigation.backtab: rebootButton
                KeyNavigation.tab: hibernateButton
            }

            SystemButton {
                id: hibernateButton
                visible: !sddm.canHibernate
                icon.source: Qt.resolvedUrl("../Assets/hibernate.svg")
                onClicked: root.hibernateClicked()

                KeyNavigation.backtab: suspendButton
                KeyNavigation.tab: sessionSelector
            }
        }

        SessionSelector {
            id: sessionSelector
            Layout.alignment: Qt.AlignCenter

            KeyNavigation.backtab: hibernateButton
        }

        z: 1
    }

    function login() {
        userField.clearError();
        passwordField.clearError();
        sddm.login(userField.text, passwordField.text, sessionSelector.currentIndex);
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            userField.triggerError("");
            passwordField.triggerError("Login failed!");
        }
    }
}
