import QtQuick
import QtMultimedia

Item {
    id: root
    anchors.fill: parent
    z: -10

    enum BgType { Video, Animated, Static }
    property int bgType: Background.BgType.Static

    // This component controls both static and animated images
    AnimatedImage {
        id: animation
        visible: root.bgType != Background.BgType.Video
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        speed: config.realValue("BackgroundPlaybackSpeed")

        // Optimization flags
        asynchronous: true
        cache: true
        mipmap: true
    }

    // this placeholder image is shown only with video backgrounds
    Image {
        id: placeholder
        anchors.fill: parent
        // visible not tied to a property to avoid unexpected reactivity
        visible: false
        source: config.stringValue("BackgroundFallbackPath")
        fillMode: Image.PreserveAspectCrop
    }

    MediaPlayer {
        id: player
        videoOutput: vidOutput
        autoPlay: true
        loops: -1
        playbackRate: config.realValue("BackgroundPlaybackSpeed")
        onPlayingChanged: function(playing) {
            if (playing) placeholder.visible = false
        }
    }

    VideoOutput {
        id: vidOutput
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        visible: root.bgType == Background.BgType.Video
    }

    Component.onCompleted: {
        const videoTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"];
        const animatedTypes = ["gif", "apng", "mng"];
        
        const bgPath = config.stringValue("BackgroundPath")
        if (bgPath == "") return;

        const filetype = bgPath.split('.').pop().toLowerCase()

        if (videoTypes.includes(filetype)) {
            bgType = Background.BgType.Video
            placeholder.visible = true
            player.source = Qt.resolvedUrl(bgPath)
            player.play()
        } else if (animatedTypes.includes(filetype)) {
            bgType = Background.BgType.Animated
            placeholder.visible = false
            animation.source = Qt.resolvedUrl(bgPath)
        } else {
            bgType = Background.BgType.Static
            placeholder.visible = false
            animation.source = Qt.resolvedUrl(bgPath)
        }
    }
}
