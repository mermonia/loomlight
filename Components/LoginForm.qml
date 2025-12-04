import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property alias avatarIcon: userAvatarButton.icon
    property alias username: userField.text

    property bool passwordHidden: true

    signal avatarClicked
    signal powerOffClicked
    signal rebootClicked
    signal suspendClicked
    signal hibernateClicked

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
        }

        InputField {
            id: passwordField
            Layout.alignment: Qt.AlignCenter
            leftIcon: Qt.resolvedUrl("../Assets/visible.svg")
            isLeftIconConnected: true
            onLeftIconClicked: function () {
                root.passwordHidden = !root.passwordHidden;
            }
        }

        LoginButton {
            id: loginButton
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40

            onClicked: function () {
                console.log(userField.text, passwordField.text, sessionSelector.currentIndex);
                sddm.login(userField.text, passwordField.text, sessionSelector.currentIndex);
            }
        }

        Row {
            id: systemButtons
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 140
            Layout.bottomMargin: 40
            spacing: 4

            SystemButton {
                visible: !sddm.canPowerOff
                icon.source: Qt.resolvedUrl("../Assets/shutdown.svg")
                onClicked: root.powerOffClicked()
            }

            SystemButton {
                visible: !sddm.canReboot
                icon.source: Qt.resolvedUrl("../Assets/reboot.svg")
                onClicked: root.rebootClicked()
            }

            SystemButton {
                visible: !sddm.canSuspend
                icon.source: Qt.resolvedUrl("../Assets/suspend.svg")
                onClicked: root.suspendClicked()
            }

            SystemButton {
                visible: !sddm.canHibernate
                icon.source: Qt.resolvedUrl("../Assets/hibernate.svg")
                onClicked: root.hibernateClicked()
            }
        }

        SessionSelector {
            id: sessionSelector
            Layout.alignment: Qt.AlignCenter
        }

        z: 1
    }
}
