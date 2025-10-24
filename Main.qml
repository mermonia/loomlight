import QtQuick
import QtQuick.Controls

import "Components"

Pane {
    contentWidth: config.intValue("ScreenWidth") ?? Screen.width
    contentHeight: config.intValue("ScreenHeight") ?? Screen.height
    padding: config.intValue("ScreenPadding")

    LayoutMirroring.enabled: config.boolValue("MirroredLayout")
    LayoutMirroring.childrenInherit: true

    Background {
        anchors.fill: parent
    }

    UserSelector {
        id: userSelector
        anchors.centerIn: parent
    }
}
