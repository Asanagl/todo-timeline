import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Rectangle {
    id: taskListRoot
    color: Material.theme === Material.Dark ? C.colorBgDark : C.colorBgLight

    property alias listView: taskListView
    property alias searchField: searchField
    property var taskEditorDialog: null
    property var deleteConfirmDialog: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 标题栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: C.heightXLarge + 16
            color: Material.primary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: C.paddingLarge
                anchors.rightMargin: C.paddingLarge

                Label {
                    text: "任务列表"
                    font.pixelSize: C.fontSizeDisplay
                    font.bold: true
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                RoundButton {
                    id: addButton
                    icon.source: "qrc:/icons/add.svg"
                    Material.background: "white"
                    Material.foreground: Material.primary
                    onClicked: taskCreator.open()
                }
            }
        }

        // 搜索框
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: C.paddingLarge
            Layout.preferredHeight: C.heightXLarge
            radius: C.radiusLarge
            color: Material.theme === Material.Dark ? C.colorSurfaceDark : C.colorSurfaceLight
            border.color: searchField.activeFocus ? C.colorPrimary : (Material.theme === Material.Dark ? C.colorBorderDark : C.colorBorderLight)
            border.width: searchField.activeFocus ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: C.paddingLarge
                anchors.rightMargin: C.paddingLarge
                spacing: C.spacingMedium

                Image {
                    source: "qrc:/icons/search.svg"
                    sourceSize: Qt.size(20, 20)
                    opacity: 0.45
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.preferredHeight: C.heightLarge
                    placeholderText: "搜索任务..."
                    background: Item {}
                    font.pixelSize: C.fontSizeLarge
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    verticalAlignment: Text.AlignVCenter

                    onTextChanged: taskManager.filterText = text
                }

                RoundButton {
                    visible: searchField.text.length > 0
                    icon.source: "qrc:/icons/close.svg"
                    icon.width: 18
                    icon.height: 18
                    flat: true
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter
                    onClicked: searchField.text = ""
                }
            }
        }

        // 任务列表
        ListView {
            id: taskListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: C.spacingMedium
            leftMargin: C.paddingLarge
            rightMargin: C.paddingLarge
            topMargin: C.spacingSmall
            bottomMargin: C.paddingLarge

            model: taskManager.filteredTasks

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 400; easing.type: Easing.OutBack }
            }

            remove: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 300 }
                NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 300 }
            }

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.InOutQuad }
            }

            delegate: TaskItem {
                width: taskListView.width - taskListView.leftMargin - taskListView.rightMargin
                task: modelData
                taskEditorDialog: taskListRoot.taskEditorDialog
                deleteConfirmDialog: taskListRoot.deleteConfirmDialog

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    z: -1
                    drag.target: parent
                    drag.axis: Drag.XAndYAxis
                    onPressed: taskListView.currentIndex = index
                    onReleased: {
                        parent.Drag.drop()
                        parent.x = 0
                        parent.y = 0
                    }
                    onClicked: parent.isExpanded = !parent.isExpanded
                }
            }

            Label {
                anchors.centerIn: parent
                text: taskManager.filterText !== "" ? "未找到匹配的任务" : "暂无任务\n点击 + 添加新任务"
                horizontalAlignment: Text.AlignHCenter
                color: C.colorTextMuted
                font.pixelSize: C.fontSizeTitle
                visible: taskListView.count === 0
            }
        }
    }

    Connections {
        target: taskManager
        function onTaskAdded(task) {
            taskListView.positionViewAtEnd()
        }
    }
}
