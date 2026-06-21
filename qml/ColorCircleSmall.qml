import QtQuick
import QtQuick.Controls.Material
import "AppConstants.js" as C

Rectangle {
    id: root

    required property int index
    required property var modelData
    property int circleIndex: index
    property color circleColor: "transparent"
    property var selector: null

    width: 28
    height: 28
    radius: 14
    color: root.circleColor
    border.color: (root.selector && root.selector.currentIndex === root.circleIndex)
        ? (Material.theme === Material.Dark ? "white" : C.colorTextDark)
        : "transparent"
    border.width: (root.selector && root.selector.currentIndex === root.circleIndex) ? 2 : 0

    Rectangle {
        anchors.centerIn: parent
        width: 10
        height: 10
        radius: 5
        color: "white"
        visible: root.selector && root.selector.currentIndex === root.circleIndex
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.selector) {
                root.selector.currentIndex = root.circleIndex
            }
        }
    }
}
