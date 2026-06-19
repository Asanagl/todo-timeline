import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    title: "Todo Timeline"
    Material.theme: darkModeEnabled ? Material.Dark : Material.Light
    Material.accent: Material.Blue

    property bool darkModeEnabled: false

    // ============ 键盘快捷键 ============

    // Ctrl+N: 新建任务
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: taskCreator.open()
    }

    // Ctrl+F: 聚焦搜索框
    Shortcut {
        sequence: "Ctrl+F"
        onActivated: taskList.focusSearchField()
    }

    // Ctrl+S: 保存数据
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            taskManager.saveTasks()
            notification.show("数据已保存")
        }
    }

    // Ctrl+E: 导出数据
    Shortcut {
        sequence: "Ctrl+E"
        onActivated: exportDialog.open()
    }

    // Ctrl+I: 导入数据
    Shortcut {
        sequence: "Ctrl+I"
        onActivated: importDialog.open()
    }

    // Ctrl+D: 切换深色模式
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            darkModeEnabled = !darkModeEnabled
            notification.show(darkModeEnabled ? "已切换到深色模式" : "已切换到浅色模式")
        }
    }

    // Esc: 关闭对话框
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (taskCreator.visible) taskCreator.close()
            else if (taskEditor.visible) taskEditor.close()
            else if (deleteConfirm.visible) deleteConfirm.close()
        }
    }

    // ============ 主布局 ============

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // 左侧任务列表
        TaskList {
            id: taskList
            SplitView.preferredWidth: 400
            SplitView.minimumWidth: 300

            function focusSearchField() {
                searchField.forceActiveFocus()
            }
        }

        // 右侧时间轴
        Timeline {
            id: timeline
            SplitView.fillWidth: true
        }
    }

    // ============ 底部工具栏 ============

    footer: ToolBar {
        Material.background: Material.primary

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            ToolButton {
                text: "今天"
                onClicked: timeline.scrollToCurrentTime()
                ToolTip.text: "回到今天 (Home)"
                ToolTip.visible: hovered
            }

            ToolButton {
                text: "分类"
                onClicked: categoryDialog.open()
                ToolTip.text: "管理分类"
                ToolTip.visible: hovered
            }

            ToolButton {
                text: "导入"
                onClicked: importDialog.open()
                ToolTip.text: "导入数据 (Ctrl+I)"
                ToolTip.visible: hovered
            }

            ToolButton {
                text: "导出"
                onClicked: exportDialog.open()
                ToolTip.text: "导出数据 (Ctrl+E)"
                ToolTip.visible: hovered
            }

            Item { Layout.fillWidth: true }

            Label {
                text: Qt.formatDate(new Date(), "yyyy年MM月dd日")
                font.pixelSize: 14
                color: "white"
            }

            Label {
                text: taskManager.totalTaskCount + " 任务"
                font.pixelSize: 12
                color: "#ccc"
                visible: taskManager.totalTaskCount > 0
            }

            Item { Layout.fillWidth: true }

            // 深色模式切换
            ToolButton {
                text: darkModeEnabled ? "浅色" : "深色"
                onClicked: {
                    darkModeEnabled = !darkModeEnabled
                    notification.show(darkModeEnabled ? "已切换到深色模式" : "已切换到浅色模式")
                }
                ToolTip.text: "切换主题 (Ctrl+D)"
                ToolTip.visible: hovered
            }

            ToolButton {
                text: "快捷键"
                onClicked: shortcutsDialog.open()
                ToolTip.text: "查看快捷键"
                ToolTip.visible: hovered
            }
        }
    }

    // ============ 对话框 ============

    // 任务创建对话框
    TaskCreator {
        id: taskCreator
        anchors.centerIn: parent
    }

    // 任务编辑对话框
    TaskEditor {
        id: taskEditor
        anchors.centerIn: parent
    }

    // 删除确认对话框
    DeleteConfirmDialog {
        id: deleteConfirm
        anchors.centerIn: parent
    }

    // 导出对话框
    FileDialog {
        id: exportDialog
        title: "导出任务数据"
        folder: shortcuts.desktop
        nameFilters: ["JSON 文件 (*.json)", "所有文件 (*)"]
        selectExisting: false
        onAccepted: {
            taskManager.exportTasks(fileUrl)
        }
    }

    // 导入对话框
    FileDialog {
        id: importDialog
        title: "导入任务数据"
        folder: shortcuts.desktop
        nameFilters: ["JSON 文件 (*.json)", "所有文件 (*)"]
        selectExisting: true
        onAccepted: {
            taskManager.importTasks(fileUrl)
        }
    }

    // 快捷键帮助对话框
    Dialog {
        id: shortcutsDialog
        title: "键盘快捷键"
        modal: true
        anchors.centerIn: parent
        width: 380
        height: 420

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 250 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 250; easing.type: Easing.OutBack }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
        }

        contentItem: ColumnLayout {
            spacing: 12

            Repeater {
                model: [
                    { key: "Ctrl+N", desc: "新建任务" },
                    { key: "Ctrl+F", desc: "搜索任务" },
                    { key: "Ctrl+S", desc: "保存数据" },
                    { key: "Ctrl+E", desc: "导出数据" },
                    { key: "Ctrl+I", desc: "导入数据" },
                    { key: "Ctrl+D", desc: "切换深色/浅色模式" },
                    { key: "Esc", desc: "关闭对话框" },
                    { key: "Home", desc: "回到今天" }
                ]

                delegate: RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Rectangle {
                        width: keyLabel.implicitWidth + 16
                        height: 28
                        radius: 4
                        color: root.darkModeEnabled ? "#424242" : "#f0f0f0"
                        border.color: root.darkModeEnabled ? "#616161" : "#ccc"
                        border.width: 1

                        Label {
                            id: keyLabel
                            anchors.centerIn: parent
                            text: modelData.key
                            font.pixelSize: 12
                            font.bold: true
                            font.family: "Consolas"
                        }
                    }

                    Label {
                        text: modelData.desc
                        font.pixelSize: 14
                        Layout.fillWidth: true
                    }
                }
            }

            Button {
                text: "关闭"
                Layout.alignment: Qt.AlignRight
                flat: true
                onClicked: shortcutsDialog.close()
            }
        }
    }

    // ============ 连接信号 ============

    Connections {
        target: taskManager

        function onTaskAdded(task) {
            notification.show("任务已添加: " + task.title)
        }

        function onTaskScheduled(task) {
            timeline.addTaskToTimeline(task)
        }

        function onTaskReminderTriggered(task) {
            reminderNotification.show("提醒: " + task.title + " 即将开始!")
        }

        function onExportFinished(success, message) {
            notification.show(message)
        }

        function onImportFinished(success, message) {
            notification.show(message)
        }
    }

    // ============ 通知组件 ============

    Notification {
        id: notification
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // 提醒通知组件（特殊样式）
    Notification {
        id: reminderNotification
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#F44336"  // 红色背景表示提醒
    }

    // 分类管理对话框
    CategoryDialog {
        id: categoryDialog
        anchors.centerIn: parent
    }

    // ============ 启动时滚动到当前时间 ============

    Component.onCompleted: {
        Qt.callLater(timeline.scrollToCurrentTime)
    }
}
