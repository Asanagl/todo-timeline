import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: taskEditorDialog
    title: "编辑任务"
    modal: true
    anchors.centerIn: parent
    width: 420
    height: 480

    property string taskId: ""
    property string taskTitle: ""
    property string taskDescription: ""
    property int taskPriority: 0
    property string taskColor: "#4A90D9"
    property string taskCategory: ""

    // 动画
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
    }

    function openEditor(task) {
        taskId = task.id
        taskTitle = task.title
        taskDescription = task.description
        taskPriority = task.priority
        taskColor = task.color
        taskCategory = task.category || ""
        titleField.text = task.title
        descriptionField.text = task.description
        prioritySelector.currentIndex = task.priority
        // 查找颜色索引
        var colors = ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]
        var colorIdx = colors.indexOf(task.color)
        colorSelector.currentIndex = colorIdx >= 0 ? colorIdx : 0
        open()
    }

    contentItem: ColumnLayout {
        spacing: 16

        // 标题输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "任务标题 *"
                font.bold: true
                font.pixelSize: 13
            }

            TextField {
                id: titleField
                Layout.fillWidth: true
                placeholderText: "输入任务标题..."
                font.pixelSize: 15
                text: taskEditorDialog.taskTitle

                background: Rectangle {
                    radius: 8
                    border.color: titleField.text.length > 0 ? "#4CAF50" : (titleField.activeFocus ? "#2196F3" : "#e0e0e0")
                    border.width: titleField.activeFocus ? 2 : 1
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }
            }
        }

        // 描述输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "任务描述"
                font.bold: true
                font.pixelSize: 13
            }

            Flickable {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                contentHeight: descriptionField.implicitHeight
                clip: true

                TextArea {
                    id: descriptionField
                    width: parent.width
                    placeholderText: "输入任务描述..."
                    wrapMode: TextArea.Wrap
                    font.pixelSize: 13
                    text: taskEditorDialog.taskDescription

                    background: Rectangle {
                        radius: 8
                        border.color: descriptionField.activeFocus ? "#2196F3" : "#e0e0e0"
                        border.width: descriptionField.activeFocus ? 2 : 1
                    }
                }
            }
        }

        // 优先级选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "优先级"
                font.bold: true
                font.pixelSize: 13
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Repeater {
                    model: [
                        { text: "低", color: "#4CAF50", value: 0 },
                        { text: "中", color: "#FF9800", value: 1 },
                        { text: "高", color: "#F44336", value: 2 }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: 8
                        color: prioritySelector.currentIndex === index ? modelData.color : (Material.theme === Material.Dark ? "#424242" : "white")
                        border.color: modelData.color
                        border.width: 2

                        Label {
                            anchors.centerIn: parent
                            text: modelData.text
                            color: prioritySelector.currentIndex === index ? "white" : modelData.color
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: prioritySelector.currentIndex = index
                        }

                        scale: prioritySelector.currentIndex === index ? 1.05 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150 } }
                    }
                }

                Item { id: prioritySelector; property int currentIndex: taskEditorDialog.taskPriority; visible: false }
            }
        }

        // 颜色选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "任务颜色"
                font.bold: true
                font.pixelSize: 13
            }

            Flow {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]

                    delegate: Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: modelData
                        border.color: colorSelector.currentIndex === index ? "#333" : "transparent"
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 14
                            height: 14
                            radius: 7
                            color: "white"
                            visible: colorSelector.currentIndex === index
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: colorSelector.currentIndex = index
                        }

                        scale: colorSelector.currentIndex === index ? 1.2 : 1.0
                        Behavior on scale { NumberAnimation { duration: 150 } }
                    }
                }

                Item { id: colorSelector; property int currentIndex: 0; visible: false }
            }
        }

        // 按钮区域
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Layout.topMargin: 8

            Button {
                text: "取消"
                flat: true
                Layout.fillWidth: true
                onClicked: taskEditorDialog.close()
            }

            Button {
                text: "保存更改"
                Material.background: Material.accent
                Material.foreground: "white"
                Layout.fillWidth: true
                enabled: titleField.text.length > 0

                onClicked: {
                    taskManager.updateTaskFull(
                        taskEditorDialog.taskId,
                        titleField.text,
                        descriptionField.text,
                        prioritySelector.currentIndex,
                        ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"][colorSelector.currentIndex],
                        taskEditorDialog.taskCategory
                    )
                    taskEditorDialog.close()
                    notification.show("任务已更新: " + titleField.text)
                }

                scale: pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }
}
