import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import "AppConstants.js" as C

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 840
    title: "Todo Timeline"
    Material.theme: darkModeEnabled ? Material.Dark : Material.Light
    Material.primary: C.colorPrimary
    Material.accent: C.colorPrimary

    property bool darkModeEnabled: false

    // ============ 键盘快捷键 ============
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: taskCreator.open()
    }

    Shortcut {
        sequence: "Ctrl+F"
        onActivated: taskList.focusSearchField()
    }

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            taskManager.saveTasks()
            notification.show("数据已保存")
        }
    }

    Shortcut {
        sequence: "Ctrl+E"
        onActivated: exportDialog.open()
    }

    Shortcut {
        sequence: "Ctrl+I"
        onActivated: importDialog.open()
    }

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            darkModeEnabled = !darkModeEnabled
            notification.show(darkModeEnabled ? "已切换到深色模式" : "已切换到浅色模式")
        }
    }

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

        TaskList {
            id: taskList
            SplitView.preferredWidth: 400
            SplitView.minimumWidth: 300
            taskEditorDialog: taskEditor
            deleteConfirmDialog: deleteConfirm

            function focusSearchField() {
                searchField.forceActiveFocus()
            }
        }

        Timeline {
            id: timeline
            SplitView.fillWidth: true
        }
    }

    // ============ 底部工具栏 ============
    footer: ToolBar {
        Material.background: C.colorPrimary

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: C.paddingLarge
            anchors.rightMargin: C.paddingLarge

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
                font.pixelSize: C.fontSizeLarge
                color: "white"
                font.bold: true
            }

            Label {
                text: taskManager.totalTaskCount + " 任务"
                font.pixelSize: C.fontSizeSmall
                color: "#e5e7eb"
                visible: taskManager.totalTaskCount > 0
            }

            Item { Layout.fillWidth: true }

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
    TaskCreator {
        id: taskCreator
        anchors.centerIn: parent
    }

    TaskEditor {
        id: taskEditor
        anchors.centerIn: parent
    }

    DeleteConfirmDialog {
        id: deleteConfirm
        anchors.centerIn: parent
    }

    FileDialog {
        id: exportDialog
        title: "导出任务数据"
        fileMode: FileDialog.SaveFile
        nameFilters: ["JSON 文件 (*.json)", "所有文件 (*)"]
        onAccepted: taskManager.exportTasks(selectedFile)
    }

    FileDialog {
        id: importDialog
        title: "导入任务数据"
        fileMode: FileDialog.OpenFile
        nameFilters: ["JSON 文件 (*.json)", "所有文件 (*)"]
        onAccepted: taskManager.importTasks(selectedFile)
    }

    Dialog {
        id: shortcutsDialog
        title: "键盘快捷键"
        modal: true
        anchors.centerIn: parent
        width: C.dialogWidthXLarge

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: C.animDurationEnter }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: C.animDurationEnter; easing.type: Easing.OutBack }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: C.animDurationSlow }
        }

        contentItem: ColumnLayout {
            spacing: C.spacingLarge

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
                    spacing: C.paddingLarge

                    Rectangle {
                        Layout.preferredWidth: keyLabel.implicitWidth + 16
                        Layout.preferredHeight: C.heightSmall
                        radius: C.radiusSmall
                        color: root.darkModeEnabled ? C.colorSurfaceDark : "#f3f4f6"
                        border.color: root.darkModeEnabled ? C.colorBorderDark : C.colorBorderLight
                        border.width: 1

                        Label {
                            id: keyLabel
                            anchors.centerIn: parent
                            text: modelData.key
                            font.pixelSize: C.fontSizeSmall
                            font.bold: true
                            font.family: "JetBrains Mono"
                        }
                    }

                    Label {
                        text: modelData.desc
                        font.pixelSize: C.fontSizeLarge
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

    Notification {
        id: reminderNotification
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        color: C.colorDanger
    }

    CategoryDialog {
        id: categoryDialog
        anchors.centerIn: parent
    }

    // ============ 启动时滚动到当前时间 ============
    Component.onCompleted: {
        Qt.callLater(timeline.scrollToCurrentTime)
    }
}
