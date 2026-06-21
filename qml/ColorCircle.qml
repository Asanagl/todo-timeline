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

    width: 34
    height: 34
    radius: 17
    color: root.circleColor
    border.color: (root.selector && root.selector.currentIndex === root.circleIndex)
        ? (Material.theme === Material.Dark ? "white" : C.colorTextDark)
        : "transparent"
    border.width: (root.selector && root.selector.currentIndex === root.circleIndex) ? 3 : 0

    Rectangle {
        anchors.centerIn: parent
        width: 14
        height: 14
        radius: 7
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
