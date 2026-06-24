import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Dialog {
    id: taskEditorDialog
    title: "编辑任务"
    modal: true
    anchors.centerIn: parent
    width: C.dialogWidthTask

    // 亚克力半透明背景
    background: Rectangle {
        color: Qt.rgba(
            themeManager.surfaceColor.r,
            themeManager.surfaceColor.g,
            themeManager.surfaceColor.b,
            themeManager.acrylicEnabled ? Math.max(0.85, themeManager.acrylicOpacity) : 1.0
        )
        border.color: themeManager.borderColor
        border.width: 1
        radius: C.radiusLarge
    }

    property string taskId: ""
    property string taskTitle: ""
    property string taskDescription: ""
    property int taskPriority: 0
    property string taskColor: themeManager.primaryColor
    property string taskCategory: ""
    property bool taskScheduled: false
    property date taskStartTime: new Date()
    property date taskEndTime: new Date()
    property bool taskHasReminder: false
    property date taskReminderTime: new Date()

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: C.animDurationDialog }
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: C.animDurationDialog; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: C.animDurationSlow }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: C.animDurationSlow }
    }

    component FormLabel: Label {
        font.bold: true
        font.pixelSize: C.fontSizeLarge
        color: themeManager.textColor
        bottomPadding: C.spacingSmall
    }

    component FormTextField: TextField {
        Layout.fillWidth: true
        Layout.preferredHeight: C.heightLarge
        font.pixelSize: C.fontSizeXLarge
        leftPadding: C.paddingLarge
        rightPadding: C.paddingLarge
        topPadding: 0
        bottomPadding: 0
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            radius: C.radiusMedium
            color: themeManager.surfaceColor
            border.color: parent.activeFocus ? themeManager.primaryColor : themeManager.borderColor
            border.width: parent.activeFocus ? 2 : 1
        }
    }

    component FormTextArea: TextArea {
        Layout.fillWidth: true
        wrapMode: TextArea.Wrap
        font.pixelSize: C.fontSizeLarge
        leftPadding: C.paddingLarge
        rightPadding: C.paddingLarge
        topPadding: C.paddingMedium
        bottomPadding: C.paddingMedium

        background: Rectangle {
            radius: C.radiusMedium
            color: themeManager.surfaceColor
            border.color: parent.activeFocus ? themeManager.primaryColor : themeManager.borderColor
            border.width: parent.activeFocus ? 2 : 1
        }
    }

    function openEditor(task) {
        taskId = task.id
        taskTitle = task.title
        taskDescription = task.description
        taskPriority = task.priority
        taskColor = task.color
        taskCategory = task.category || ""
        taskScheduled = task.scheduled
        taskHasReminder = task.hasReminder

        if (task.scheduled && task.startTime) {
            taskStartTime = task.startTime
            taskEndTime = task.endTime
        } else {
            var now = new Date()
            taskStartTime = now
            var endDefault = new Date(now.getTime() + 3600000)
            taskEndTime = endDefault
        }

        if (task.hasReminder && task.reminderTime) {
            taskReminderTime = task.reminderTime
        } else {
            taskReminderTime = taskStartTime
        }

        titleField.text = task.title
        descriptionField.text = task.description
        prioritySelector.currentIndex = task.priority
        var colorIdx = C.taskColors.indexOf(task.color)
        colorSelector.currentIndex = colorIdx >= 0 ? colorIdx : 0

        // 分类下拉
        categoryComboBox.refreshCategoryModel()
        var catIdx = 0
        for (var i = 0; i < categoryComboBox.model.length; i++) {
            if (categoryComboBox.model[i].id === (task.category || "")) {
                catIdx = i
                break
            }
        }
        categoryComboBox.currentIndex = catIdx

        // 时间安排
        scheduleCheckBox.checked = task.scheduled
        if (task.scheduled && task.startTime) {
            startHourTumbler.currentIndex = task.startTime.getHours()
            startMinuteTumbler.currentIndex = task.startTime.getMinutes()
            endHourTumbler.currentIndex = task.endTime.getHours()
            endMinuteTumbler.currentIndex = task.endTime.getMinutes()
        } else {
            var n = new Date()
            startHourTumbler.currentIndex = n.getHours()
            startMinuteTumbler.currentIndex = 0
            endHourTumbler.currentIndex = (n.getHours() + 1) % 24
            endMinuteTumbler.currentIndex = 0
        }

        // 提醒设置
        reminderCheckBox.checked = task.hasReminder
        if (task.hasReminder && task.scheduled && task.startTime) {
            // 根据 reminderTime 和 startTime 反推提前分钟数
            var diffMs = task.startTime.getTime() - task.reminderTime.getTime()
            var advanceMin = Math.max(0, Math.floor(diffMs / 60000))
            reminderAdvanceSpinBox.value = Math.min(120, advanceMin)
        } else {
            reminderAdvanceSpinBox.value = 15
        }

        open()
    }

    contentItem: ColumnLayout {
        spacing: C.spacingXXLarge
        anchors.margins: C.paddingLarge

        // 标题输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "任务标题 *" }

            FormTextField {
                id: titleField
                placeholderText: "输入任务标题..."
                text: taskEditorDialog.taskTitle
                maximumLength: 200
                onAccepted: {
                    if (saveButton.enabled) saveButton.clicked()
                }
            }
        }

        // 描述输入
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "任务描述" }

            Flickable {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                contentWidth: width
                contentHeight: descriptionField.implicitHeight
                clip: true

                FormTextArea {
                    id: descriptionField
                    width: parent.width
                    placeholderText: "输入任务描述..."
                    text: taskEditorDialog.taskDescription
                }
            }
        }

        // 分类选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "分类" }

            ComboBox {
                id: categoryComboBox
                Layout.fillWidth: true
                Layout.preferredHeight: C.heightLarge
                textRole: "name"
                valueRole: "id"

                function refreshCategoryModel() {
                    var items = [{ name: "无分类", id: "" }]
                    if (taskManager.categories) {
                        for (var i = 0; i < taskManager.categories.length; i++) {
                            var cat = taskManager.categories[i]
                            items.push({ name: cat.name, id: cat.id })
                        }
                    }
                    categoryComboBox.model = items
                }

                background: Rectangle {
                    radius: C.radiusMedium
                    color: themeManager.surfaceColor
                    border.color: parent.activeFocus ? themeManager.primaryColor : themeManager.borderColor
                    border.width: parent.activeFocus ? 2 : 1
                }
            }
        }

        // 优先级选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "优先级" }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                Repeater {
                    model: C.priorities
                    delegate: PriorityButton {
                        btnColor: modelData.color
                        btnText: modelData.text
                        selector: prioritySelector
                    }
                }

                Item { id: prioritySelector; property int currentIndex: taskEditorDialog.taskPriority; visible: false }
            }
        }

        // 时间安排
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "时间安排" }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                CheckBox {
                    id: scheduleCheckBox
                    text: "安排时间"
                }

                Item { Layout.fillWidth: true }
            }

            ColumnLayout {
                Layout.fillWidth: true
                visible: scheduleCheckBox.checked
                spacing: C.spacingLarge

                RowLayout {
                    Layout.fillWidth: true
                    spacing: C.spacingLarge

                    Label {
                        text: "开始时间:"
                        Layout.preferredWidth: 80
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Tumbler {
                        id: startHourTumbler
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        model: 24
                        currentIndex: taskEditorDialog.taskStartTime.getHours()
                        visibleItemCount: 3
                    }

                    Label {
                        text: ":"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Tumbler {
                        id: startMinuteTumbler
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        model: 60
                        currentIndex: taskEditorDialog.taskStartTime.getMinutes()
                        visibleItemCount: 3
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: C.spacingLarge

                    Label {
                        text: "结束时间:"
                        Layout.preferredWidth: 80
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Tumbler {
                        id: endHourTumbler
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        model: 24
                        currentIndex: taskEditorDialog.taskEndTime.getHours()
                        visibleItemCount: 3
                    }

                    Label {
                        text: ":"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Tumbler {
                        id: endMinuteTumbler
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        model: 60
                        currentIndex: taskEditorDialog.taskEndTime.getMinutes()
                        visibleItemCount: 3
                    }
                }
            }
        }

        // 提醒设置
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "提醒设置" }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                CheckBox {
                    id: reminderCheckBox
                    text: "设置提醒"
                    enabled: scheduleCheckBox.checked
                }

                Item { Layout.fillWidth: true }
            }

            RowLayout {
                visible: reminderCheckBox.checked && scheduleCheckBox.checked
                Layout.fillWidth: true
                spacing: C.spacingMedium

                Label {
                    text: "提前"
                    Layout.preferredWidth: 72
                    Layout.alignment: Qt.AlignVCenter
                    color: Material.theme === Material.Dark ? C.colorLabelMutedDark : C.colorLabelMutedLight
                }

                SpinBox {
                    id: reminderAdvanceSpinBox
                    Layout.fillWidth: true
                    from: 0
                    to: 120
                    value: 15
                    stepSize: 5
                    editable: true
                }

                Label {
                    text: "分钟"
                    Layout.alignment: Qt.AlignVCenter
                    color: Material.theme === Material.Dark ? C.colorLabelMutedDark : C.colorLabelMutedLight
                }
            }
        }

        // 颜色选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "任务颜色" }

            Flow {
                Layout.fillWidth: true
                spacing: C.spacingMedium

                Repeater {
                    model: C.taskColors
                    delegate: ColorCircle {
                        circleColor: modelData
                        selector: colorSelector
                    }
                }

                Item { id: colorSelector; property int currentIndex: 0; visible: false }
            }
        }

        // 按钮区域
        RowLayout {
            Layout.fillWidth: true
            spacing: C.spacingLarge
            Layout.topMargin: C.spacingLarge

            Button {
                text: "取消"
                flat: true
                Layout.fillWidth: true
                onClicked: taskEditorDialog.close()
            }

            Button {
                id: saveButton
                text: "保存更改"
                Material.background: themeManager.primaryColor
                Material.foreground: "white"
                Layout.fillWidth: true
                Layout.preferredHeight: C.heightLarge
                enabled: titleField.text.trim().length > 0
                highlighted: true

                onClicked: {
                    var selectedCategory = categoryComboBox.model[categoryComboBox.currentIndex].id

                    // 更新基本信息
                    taskManager.updateTaskFull(
                        taskEditorDialog.taskId,
                        titleField.text,
                        descriptionField.text,
                        prioritySelector.currentIndex,
                        C.taskColors[colorSelector.currentIndex],
                        selectedCategory
                    )

                    // 更新时间安排
                    if (scheduleCheckBox.checked) {
                        var startTime = new Date()
                        startTime.setHours(startHourTumbler.currentIndex, startMinuteTumbler.currentIndex, 0, 0)
                        var endTime = new Date()
                        endTime.setHours(endHourTumbler.currentIndex, endMinuteTumbler.currentIndex, 0, 0)
                        taskManager.updateTaskSchedule(taskEditorDialog.taskId, startTime, endTime, true)

                        // 更新提醒
                        if (reminderCheckBox.checked) {
                            var reminderTime = new Date(startTime)
                            reminderTime.setMinutes(reminderTime.getMinutes() - reminderAdvanceSpinBox.value)
                            taskManager.updateTaskReminder(taskEditorDialog.taskId, true, reminderTime)
                        } else {
                            taskManager.updateTaskReminder(taskEditorDialog.taskId, false, null)
                        }
                    } else {
                        taskManager.updateTaskSchedule(taskEditorDialog.taskId, null, null, false)
                        taskManager.updateTaskReminder(taskEditorDialog.taskId, false, null)
                    }

                    taskEditorDialog.close()
                    notification.show("任务已更新: " + titleField.text)
                }
            }
        }
    }
}
