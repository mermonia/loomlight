pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: selectSession

    property string highlightedBackgroundColor: config.stringValue("SessionSelectorDropdownHighlightedBackgroundColor")
    property string bgColor: config.stringValue("SessionSelectorButtonBackgroundColor")

    property int borderRadius: config.intValue("SessionSelectorBorderRadius")

    implicitWidth: config.intValue("SessionSelectorButtonWidth")
    implicitHeight: config.intValue("SessionSelectorButtonHeight")

    model: sessionModel
    currentIndex: model.lastIndex
    textRole: "name"

    hoverEnabled: true

    states: [
        State {
            name: "focused"
            when: selectSession.focus
            PropertyChanges {
                bg.color: config.stringValue("SessionSelectorButtonFocusedBackgroundColor")
            }
        }
    ]

    background: Rectangle {
        id: bg
        anchors.fill: parent
        color: selectSession.bgColor

        border {
            color: config.stringValue("SessionSelectorButtonBorderColor")
            width: config.intValue("SessionSelectorButtonBorderWidth")
        }

        topRightRadius: selectSession.borderRadius
        topLeftRadius: selectSession.borderRadius
        bottomRightRadius: selectSession.down ? 0 : selectSession.borderRadius
        bottomLeftRadius: selectSession.down ? 0 : selectSession.borderRadius
    }

    contentItem: Text {
        id: label

        text: selectSession.currentText
        color: config.stringValue("SessionSelectorButtonTextColor")

        font.family: config.stringValue("FontFamily")
        font.pointSize: config.intValue("SessionSelectorFontSize")

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        elide: Text.ElideRight
    }

    indicator: null

    delegate: ItemDelegate {
        id: delegate

        required property string name
        required property int index

        width: selectSession.width

        contentItem: Text {
            text: delegate.name

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: config.stringValue("FontFamily")
            font.pointSize: config.intValue("SessionSelectorFontSize")

            color: config.stringValue("SessionSelectorDropdownTextColor")
        }

        background: Rectangle {
            id: bg
            color: "transparent"

            border {
                color: config.stringValue("SessionSelectorDropdownEntryBorderColor")
                width: config.intValue("SessionSelectorDropdownEntryBorderWidth")
            }

            radius: config.intValue("SessionSelectorDropdownEntryBorderRadius")
        }

        states: [
            State {
                name: "highlighted"
                when: selectSession.highlightedIndex === delegate.index
                PropertyChanges {
                    target: bg
                    color: selectSession.highlightedBackgroundColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "bg.color"
                    duration: 40
                }
            }
        ]
    }

    popup: Popup {
        id: popupHandler

        width: selectSession.width
        y: selectSession.height
        padding: 0
        implicitHeight: contentItem.implicitHeight

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: selectSession.popup.visible ? selectSession.delegateModel : null
            currentIndex: selectSession.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            color: config.stringValue("SessionSelectorDropdownBackgroundColor")
            layer.enabled: true

            border {
                color: config.stringValue("SessionSelectorDropdownBorderColor")
                width: config.intValue("SessionSelectorDropdownBorderWidth")
            }

            bottomRightRadius: selectSession.borderRadius
            bottomLeftRadius: selectSession.borderRadius
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 50
            }
        }
    }
}
