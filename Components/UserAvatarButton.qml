import QtQuick
import QtQuick.Controls

Control {
    id: root

    required property int diameter
    property alias icon: userAvatarImage.source

    implicitWidth: diameter
    implicitHeight: diameter

    signal clicked

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: root.clicked()
    }

    contentItem: CircleCroppedImage {
        id: userAvatarImage
        diameter: root.diameter
        fillMode: Image.PreserveAspectCrop
        backgroundColor: config.stringValue("UserAvatarBackgroundColor")
    }

    Text {
        id: overlayText
        text: "Select User"
        anchors.centerIn: parent
        color: config.stringValue("UserAvatarOverlayTextColor")
        opacity: hoverHandler.hovered ? 1.0 : 0.0

        font.family: config.stringValue("UserAvatarOverlayFontFamily")
        font.pointSize: config.stringValue("UserAvatarOverlayFontSize")
        font.bold: true

        z: 10

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: shade
        anchors.fill: parent
        color: "black"
        radius: width / 2
        opacity: hoverHandler.hovered ? 0.5 : 0.0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }
}
