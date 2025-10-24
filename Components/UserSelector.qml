pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    anchors.centerIn: parent
    z: 1

    width: config.intValue("CarouselWidth")
    height: config.intValue("CarouselHeight")

    signal selected(string name)

    Component {
        id: delegate

        Column {
            id: wrapper

            required property string name
            required property url icon
            required property int index

            spacing: 8
            opacity: PathView.iconOpacity

            property real pulseScale: 1.0
            property real hoverScale: hoverHandler.hovered ? 1.2 : 1.0
            scale: PathView.iconScale * hoverScale * pulseScale

            CircleCroppedImage {
                anchors.horizontalCenter: parent.horizontalCenter
                source: wrapper.icon
                fillMode: Image.PreserveAspectCrop
                diameter: config.intValue("CarouselAvatarDiameter")

                border.width: config.stringValue("CarouselAvatarBorderWidth")
                border.color: config.stringValue("CarouselAvatarBorderColor")

                Behavior on border.color {
                    ColorAnimation {
                        duration: 200
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: wrapper.name

                font.family: config.stringValue("FontFamily")
                font.pointSize: config.intValue("FontSize")
                font.weight: Font.Light
            }

            HoverHandler {
                id: hoverHandler
                acceptedDevices: PointerDevice.AllDevices
                cursorShape: Qt.PointingHandCursor
            }

            Behavior on hoverScale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
            
            TapHandler {
                id: tapHandler
                acceptedDevices: PointerDevice.AllDevices
                gesturePolicy: TapHandler.ReleaseWithinBounds
                longPressThreshold: 0.5 
                onTapped: function() {
                    if (carousel.currentIndex == wrapper.index) {
                        root.selected(wrapper.name)
                        pulse.start()
                    } else {
                        carousel.currentIndex = wrapper.index
                    }
                }
            }

            SequentialAnimation {
                id: pulse
                running: false
                NumberAnimation { target: wrapper; property: "pulseScale"; to: 1.2; duration: 75}
                NumberAnimation { target: wrapper; property: "pulseScale"; to: 1.0; duration: 75}
            }
        }
    }

    PathView {
        id: carousel
        anchors.fill: parent
        z: 1
        pathItemCount: config.intValue("CarouselAvatarCount")
        model: userModel
        delegate: delegate
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        path: Path {
            startX: 0; startY: carousel.height / 2 - 32
            PathAttribute { name: "iconScale"; value: config.realValue("CarouselMinScale") }
            PathAttribute { name: "iconOpacity"; value: config.realValue("CarouselMinOpacity")}

            PathCurve { relativeX: carousel.width / 2; relativeY: 64 }
            PathAttribute { name: "iconScale"; value: config.realValue("CarouselMaxScale") }
            PathAttribute { name: "iconOpacity"; value: config.realValue("CarouselMaxOpacity")}

            PathCurve { relativeX: carousel.width / 2; relativeY: -64 }
            PathAttribute { name: "iconScale"; value: config.realValue("CarouselMinScale") }
            PathAttribute { name: "iconOpacity"; value: config.realValue("CarouselMinOpacity")}
        }
    }
}
