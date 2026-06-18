import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: taskItemRoot
    height: 80
    radius: 8
    color: Material.theme === Material.Dark ? "#424242" : "white"
    border.color: task.completed ? "#4CAF50" : (Material.theme === Material.Dark ? "#616161" : "#e0e0e0")
    border.width: task.completed ? 2 : 1

    property var task: null
    property bool isExpanded: false

    // 动画
    Behavior on height {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // 主内容
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // 完成状态复选框
        CheckBox {
            id: completionCheckBox
            checked: task.completed
            Material.accent: "#4CAF50"

            onToggled: {
                taskManager.toggleTaskCompletion(task.id)
                if (checked) {
                    completionAnimation.start()
                }
            }

            // 完成动画
            SequentialAnimation {
                id: completionAnimation
                ScaleAnimator {
                    target: completionCheckBox
                    from: 1.0
                    to: 1.3
                    duration: 150
                }
                ScaleAnimator {
                    target: completionCheckBox
                    from: 1.3
                    to: 1.0
                    duration: 150
                }
            }
        }

        // 任务信息
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Label {
                id: titleLabel
                text: task.title
                font.pixelSize: 16
                font.bold: true
                color: task.completed ? "#9e9e9e" : (Material.theme === Material.Dark ? "#ffffff" : "#212121")
                elide: Text.ElideRight
                Layout.fillWidth: true

                // 删除线动画
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 2
                    color: "#9e9e9e"
                    width: task.completed ? parent.width : 0

                    Behavior on width {
                        NumberAnimation { duration: 300 }
                    }
                }
            }

            Label {
                id: descriptionLabel
                text: task.description || "暂无描述"
                font.pixelSize: 12
                color: Material.theme === Material.Dark ? "#aaaaaa" : "#757575"
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: isExpanded
                opacity: isExpanded ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // 时间信息
            RowLayout {
                spacing: 8
                visible: task.scheduled

                Label {
                    text: "🕐"
                    font.pixelSize: 12
                }

                Label {
                    text: {
                        if (task.scheduled) {
                            var start = Qt.formatTime(task.startTime, "HH:mm")
                            var end = Qt.formatTime(task.endTime, "HH:mm")
                            return start + " - " + end
                        }
                        return ""
                    }
                    font.pixelSize: 12
                    color: "#4A90D9"
                }
            }
        }

        // 优先级指示器
        Rectangle {
            width: 4
            height: parent.height - 24
            radius: 2
            color: {
                switch(task.priority) {
                case 0: return "#4CAF50"
                case 1: return "#FF9800"
                case 2: return "#F44336"
                default: return "#4CAF50"
                }
            }
        }

        // 操作按钮
        ColumnLayout {
            spacing: 4

            RoundButton {
                icon.source: "qrc:/icons/edit.svg"
                icon.width: 16
                icon.height: 16
                flat: true
                onClicked: {
                    taskEditor.openEditor(task)
                }

                scale: hovered ? 1.2 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: 150 }
                }
            }

            RoundButton {
                icon.source: "qrc:/icons/delete.svg"
                icon.width: 16
                icon.height: 16
                flat: true
                Material.foreground: "#F44336"
                onClicked: {
                    deleteConfirm.confirmDelete(task.id, task.title)
                }

                scale: hovered ? 1.2 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: 150 }
                }
            }
        }
    }

    // 点击展开/收起
    MouseArea {
        anchors.fill: parent
        anchors.leftMargin: 60
        onClicked: {
            isExpanded = !isExpanded
        }
    }

    // 进入动画
    Component.onCompleted: {
        opacity = 0
        scale = 0.8
        enterAnimation.start()
    }

    ParallelAnimation {
        id: enterAnimation

        NumberAnimation {
            target: taskItemRoot
            property: "opacity"
            from: 0
            to: 1.0
            duration: 400
        }

        NumberAnimation {
            target: taskItemRoot
            property: "scale"
            from: 0.8
            to: 1.0
            duration: 400
            easing.type: Easing.OutBack
        }
    }
}
