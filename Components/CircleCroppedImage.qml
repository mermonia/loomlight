import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property int diameter

    property alias source: img.source
    property alias fillMode: img.fillMode

    property alias border: borderHelper.border

    width: diameter
    height: diameter

    Image {
        id: img
        anchors.fill: parent
        smooth: true
        visible: false
        cache: true
    }

    ShaderEffectSource {
        id: mask
        sourceItem: Rectangle {
            width: root.diameter
            height: root.diameter
            radius: width / 2
            color: "white"
        }
        live: true
        hideSource: true
        // textureSize: Qt.size(root.width * Screen.devicePixelRatio, root.height * Screen.devicePixelRatio)
    }

    Rectangle {
        id: borderHelper
        anchors.centerIn: root
        z: 10
        width: root.diameter + border.width * 2
        height: root.diameter + border.width * 2
        radius: width / 2
        border.width: 0
        border.color: "transparent"
        color: "transparent"
    }

    MultiEffect {
        anchors.fill: parent
        z: 5
        source: img
        maskEnabled: true
        maskSource: mask
        maskThresholdMin: 0.4
        maskSpreadAtMin: 0.1
        smooth: true
    }
}
