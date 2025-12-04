import QtQuick

Text {
    id: clock

    text: Qt.formatTime(new Date(), "hh:mm")
    color: config.stringValue("ClockTextColor")

    font.pointSize: config.intValue("ClockFontSize")
    font.family: config.stringValue("ClockFontFamily")
    font.bold: true

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm")
    }

    // for testing purposes .-.
    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        z: -1
    }
}
