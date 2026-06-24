import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Dialog {
    id: taskCreatorDialog
    title: "创建新任务"
    modal: true
    anchors.centerIn: parent
    width: C.dialogWidthTask

    property string selectedCategoryId: ""

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
                maximumLength: 200
                onAccepted: {
                    if (createButton.enabled) createButton.clicked()
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

                Component.onCompleted: refreshCategoryModel()

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

                onCurrentIndexChanged: {
                    var item = model[currentIndex]
                    taskCreatorDialog.selectedCategoryId = item ? item.id : ""
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

                Item { id: prioritySelector; property int currentIndex: 0; visible: false }
            }
        }

        // 时间设置（可选）
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "安排时间（可选）" }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                CheckBox {
                    id: scheduleCheckBox
                    text: "立即安排时间"
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
                        currentIndex: new Date().getHours()
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
                        currentIndex: 0
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
                        currentIndex: (new Date().getHours() + 1) % 24
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
                        currentIndex: 0
                        visibleItemCount: 3
                    }
                }
            }
        }

        // 提醒设置
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "提醒设置（可选）" }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                CheckBox {
                    id: reminderCheckBox
                    text: "设置提醒"
                }

                Item { Layout.fillWidth: true }
            }

            RowLayout {
                visible: reminderCheckBox.checked
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
                onClicked: {
                    taskCreatorDialog.close()
                    taskCreatorDialog.resetForm()
                }
            }

            Button {
                id: createButton
                text: "创建任务"
                Material.background: themeManager.primaryColor
                Material.foreground: "white"
                Layout.fillWidth: true
                Layout.preferredHeight: C.heightLarge
                enabled: titleField.text.trim().length > 0
                highlighted: true

                onClicked: {
                    var newTaskId = taskCreatorDialog.selectedCategoryId !== ""
                        ? taskManager.addTaskWithCategory(titleField.text, descriptionField.text, taskCreatorDialog.selectedCategoryId)
                        : taskManager.addTask(titleField.text, descriptionField.text)

                    if (scheduleCheckBox.checked && newTaskId !== "") {
                        var startTime = new Date()
                        startTime.setHours(startHourTumbler.currentIndex, startMinuteTumbler.currentIndex, 0, 0)
                        var endTime = new Date()
                        endTime.setHours(endHourTumbler.currentIndex, endMinuteTumbler.currentIndex, 0, 0)

                        taskManager.scheduleTask(newTaskId, startTime, endTime)

                        if (reminderCheckBox.checked) {
                            var reminderTime = new Date(startTime)
                            reminderTime.setMinutes(reminderTime.getMinutes() - reminderAdvanceSpinBox.value)
                            taskManager.setTaskReminder(newTaskId, reminderTime)
                        }
                    }

                    taskCreatorDialog.close()
                    taskCreatorDialog.resetForm()
                }
            }
        }
    }

    function resetForm() {
        titleField.text = ""
        descriptionField.text = ""
        prioritySelector.currentIndex = 0
        colorSelector.currentIndex = 0
        categoryComboBox.refreshCategoryModel()
        categoryComboBox.currentIndex = 0
        selectedCategoryId = ""
        scheduleCheckBox.checked = false
        reminderCheckBox.checked = false
        startHourTumbler.currentIndex = new Date().getHours()
        startMinuteTumbler.currentIndex = 0
        endHourTumbler.currentIndex = (new Date().getHours() + 1) % 24
        endMinuteTumbler.currentIndex = 0
        reminderAdvanceSpinBox.value = 15
    }

    onOpened: {
        resetForm()
        titleField.forceActiveFocus()
    }
}
