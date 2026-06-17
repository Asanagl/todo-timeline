import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    id: notificationRoot
    width: notificationText.implicitWidth + 40
    height: 40
    radius: 20
    color: "#323232"
    opacity: 0
    scale: 0.8

    property alias text: notificationText.text

    // 显示动画
    function show(message) {
        text = message
        showAnimation.start()
        hideTimer.restart()
    }

    Label {
        id: notificationText
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 14
    }

    // 显示动画
    ParallelAnimation {
        id: showAnimation

        NumberAnimation {
            target: notificationRoot
            property: "opacity"
            from: 0
            to: 1.0
            duration: 300
            easing.type: Easing.OutQuad
        }

        NumberAnimation {
            target: notificationRoot
            property: "scale"
            from: 0.8
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
        }

        NumberAnimation {
            target: notificationRoot
            property: "y"
            from: notificationRoot.y + 20
            to: notificationRoot.y
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    // 隐藏动画
    ParallelAnimation {
        id: hideAnimation

        NumberAnimation {
            target: notificationRoot
            property: "opacity"
            from: 1.0
            to: 0
            duration: 200
        }

        NumberAnimation {
            target: notificationRoot
            property: "scale"
            from: 1.0
            to: 0.8
            duration: 200
        }
    }

    // 自动隐藏定时器
    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: {
            hideAnimation.start()
        }
    }

    // 点击关闭
    MouseArea {
        anchors.fill: parent
        onClicked: {
            hideAnimation.start()
        }
    }
}
