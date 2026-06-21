import QtQuick
import QtQuick.Controls
import "AppConstants.js" as C

Rectangle {
    id: notificationRoot
    width: notificationText.implicitWidth + 40
    height: C.heightLarge
    radius: C.heightLarge / 2
    color: "#323232"
    opacity: 0
    scale: 0.8

    property alias text: notificationText.text

    function show(message) {
        text = message
        showAnimation.start()
        hideTimer.restart()
    }

    Label {
        id: notificationText
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: C.fontSizeLarge
    }

    ParallelAnimation {
        id: showAnimation

        NumberAnimation {
            target: notificationRoot
            property: "opacity"
            from: 0
            to: 1.0
            duration: C.animDurationDialog
            easing.type: Easing.OutQuad
        }

        NumberAnimation {
            target: notificationRoot
            property: "scale"
            from: 0.8
            to: 1.0
            duration: C.animDurationDialog
            easing.type: Easing.OutBack
        }

        NumberAnimation {
            target: notificationRoot
            property: "y"
            from: -20
            to: 0
            duration: C.animDurationDialog
            easing.type: Easing.OutQuad
        }
    }

    ParallelAnimation {
        id: hideAnimation

        NumberAnimation {
            target: notificationRoot
            property: "opacity"
            from: 1.0
            to: 0
            duration: C.animDurationSlow
        }

        NumberAnimation {
            target: notificationRoot
            property: "scale"
            from: 1.0
            to: 0.8
            duration: C.animDurationSlow
        }
    }

    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: hideAnimation.start()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: hideAnimation.start()
    }
}
