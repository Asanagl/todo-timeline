import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Rectangle {
    id: root

    required property int index
    required property var modelData
    property int btnIndex: index
    property color btnColor: "transparent"
    property string btnText: ""
    property var selector: null

    Layout.fillWidth: true
    Layout.preferredHeight: C.heightMedium
    radius: C.radiusMedium
    color: (root.selector && root.selector.currentIndex === root.btnIndex)
        ? root.btnColor
        : (Material.theme === Material.Dark ? C.colorSurfaceDark : C.colorSurfaceLight)
    border.color: root.btnColor
    border.width: 2

    Label {
        anchors.centerIn: parent
        text: root.btnText
        color: (root.selector && root.selector.currentIndex === root.btnIndex) ? C.colorTextOnAccent : root.btnColor
        font.bold: true
        font.pixelSize: C.fontSizeMedium
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.selector) {
                root.selector.currentIndex = root.btnIndex
            }
        }
    }
}
