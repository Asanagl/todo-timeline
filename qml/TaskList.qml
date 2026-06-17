import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: taskListRoot
    color: Material.theme === Material.Dark ? "#303030" : "#f5f5f5"

    property alias listView: taskListView

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 标题栏
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Material.primary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Label {
                    text: "任务列表"
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                // 添加任务按钮
                RoundButton {
                    id: addButton
                    icon.source: "qrc:/icons/add.svg"
                    Material.background: Material.accent
                    Material.foreground: "white"
                    onClicked: {
                        taskCreator.open()
                    }

                    // 悬停动画
                    scale: hovered ? 1.1 : 1.0
                    Behavior on scale {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }

        // 搜索框
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: Material.theme === Material.Dark ? "#424242" : "white"
            border.color: Material.theme === Material.Dark ? "#616161" : "#e0e0e0"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Image {
                    source: "qrc:/icons/search.svg"
                    sourceSize: Qt.size(20, 20)
                    opacity: 0.5
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "搜索任务..."
                    background: Item {}
                    font.pixelSize: 14

                    onTextChanged: {
                        taskManager.filterText = text
                    }

                    // 清除按钮
                    RoundButton {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        visible: searchField.text.length > 0
                        icon.source: "qrc:/icons/close.svg"
                        icon.width: 16
                        icon.height: 16
                        flat: true
                        onClicked: searchField.text = ""

                        scale: hovered ? 1.2 : 1.0
                        Behavior on scale { NumberAnimation { duration: 100 } }
                    }
                }
            }
        }

        // 任务列表
        ListView {
            id: taskListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            leftMargin: 16
            rightMargin: 16
            topMargin: 8
            bottomMargin: 16

            model: taskManager.tasks

            // 添加动画
            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 400; easing.type: Easing.OutBack }
            }

            // 移除动画
            remove: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 300 }
                NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 300 }
            }

            // 移动动画
            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.InOutQuad }
            }

            delegate: TaskItem {
                width: taskListView.width - 32
                task: modelData
                visible: {
                    if (taskManager.filterText === "") return true
                    return modelData.title.toLowerCase().indexOf(taskManager.filterText.toLowerCase()) >= 0 ||
                           modelData.description.toLowerCase().indexOf(taskManager.filterText.toLowerCase()) >= 0
                }
                height: visible ? 80 : 0
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }

                // 拖拽支持
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XAndYAxis

                    onPressed: {
                        taskListView.currentIndex = index
                        parent.grabToImage(function(result) {
                            parent.Drag.imageSource = result.url
                        })
                    }

                    onReleased: {
                        parent.Drag.drop()
                        parent.x = 0
                        parent.y = 0
                    }
                }
            }

            // 空状态提示
            Label {
                anchors.centerIn: parent
                text: taskManager.filterText !== "" ? "未找到匹配的任务" : "暂无任务\n点击 + 添加新任务"
                horizontalAlignment: Text.AlignHCenter
                color: "#9e9e9e"
                font.pixelSize: 16
                visible: taskManager.taskCountFiltered() === 0
            }
        }
    }

    // 连接信号
    Connections {
        target: taskManager

        function onTaskAdded(task) {
            taskListView.positionViewAtEnd()
        }
    }
}
