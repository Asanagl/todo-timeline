import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: taskCreatorDialog
    title: "创建新任务"
    modal: true
    anchors.centerIn: parent
    width: 420
    height: 580

    property string selectedCategoryId: ""

    // 动画
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 200 }
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
                maximumLength: 200

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

                    background: Rectangle {
                        radius: 8
                        border.color: descriptionField.activeFocus ? "#2196F3" : "#e0e0e0"
                        border.width: descriptionField.activeFocus ? 2 : 1
                    }
                }
            }
        }

        // 分类选择
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "分类"
                font.bold: true
                font.pixelSize: 13
            }

            ComboBox {
                id: categoryComboBox
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"

                Component.onCompleted: {
                    refreshCategoryModel()
                }

                function refreshCategoryModel() {
                    var items = []
                    items.push({ name: "无分类", id: "" })
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
                    selectedCategoryId = item ? item.id : ""
                }

                background: Rectangle {
                    radius: 8
                    border.color: categoryComboBox.activeFocus ? "#2196F3" : "#e0e0e0"
                    border.width: categoryComboBox.activeFocus ? 2 : 1
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
                        width: 80
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
                            font.pixelSize: 13
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

                Item { id: prioritySelector; property int currentIndex: 0; visible: false }
            }
        }

        // 时间设置（可选）
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                text: "安排时间（可选）"
                font.bold: true
                font.pixelSize: 13
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                CheckBox {
                    id: scheduleCheckBox
                    text: "立即安排时间"
                }

                Item { Layout.fillWidth: true }
            }

            // 时间选择器
            ColumnLayout {
                visible: scheduleCheckBox.checked
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Label {
                        text: "开始时间:"
                        Layout.preferredWidth: 80
                    }

                    Tumbler {
                        id: startHourTumbler
                        Layout.preferredWidth: 60
                        model: 24
                        currentIndex: new Date().getHours()
                        visibleItemCount: 3
                    }

                    Label { text: ":" }

                    Tumbler {
                        id: startMinuteTumbler
                        Layout.preferredWidth: 60
                        model: 60
                        currentIndex: 0
                        visibleItemCount: 3
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Label {
                        text: "结束时间:"
                        Layout.preferredWidth: 80
                    }

                    Tumbler {
                        id: endHourTumbler
                        Layout.preferredWidth: 60
                        model: 24
                        currentIndex: (new Date().getHours() + 1) % 24
                        visibleItemCount: 3
                    }

                    Label { text: ":" }

                    Tumbler {
                        id: endMinuteTumbler
                        Layout.preferredWidth: 60
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
            spacing: 6

            Label {
                text: "提醒设置（可选）"
                font.bold: true
                font.pixelSize: 13
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                CheckBox {
                    id: reminderCheckBox
                    text: "设置提醒"
                }

                Item { Layout.fillWidth: true }
            }

            RowLayout {
                visible: reminderCheckBox.checked
                Layout.fillWidth: true
                spacing: 12

                Label {
                    text: "提醒时间:"
                    Layout.preferredWidth: 80
                }

                SpinBox {
                    id: reminderHourSpinBox
                    from: 0
                    to: 23
                    value: new Date().getHours()
                    editable: true
                }

                Label { text: ":" }

                SpinBox {
                    id: reminderMinuteSpinBox
                    from: 0
                    to: 59
                    value: 0
                    editable: true
                }

                Label {
                    text: "提前"
                    color: Material.theme === Material.Dark ? "#aaa" : "#666"
                }

                SpinBox {
                    id: reminderAdvanceSpinBox
                    from: 0
                    to: 120
                    value: 15
                    stepSize: 5
                    editable: true
                }

                Label {
                    text: "分钟"
                    color: Material.theme === Material.Dark ? "#aaa" : "#666"
                }
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
                spacing: 8

                Repeater {
                    model: ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]

                    delegate: Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: modelData
                        border.color: colorSelector.currentIndex === index ? "white" : "transparent"
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
                onClicked: {
                    taskCreatorDialog.close()
                    resetForm()
                }
            }

            Button {
                text: "创建任务"
                Material.background: Material.accent
                Material.foreground: "white"
                Layout.fillWidth: true
                enabled: titleField.text.trim().length > 0

                onClicked: {
                    // 创建任务
                    if (selectedCategoryId !== "") {
                        taskManager.addTaskWithCategory(titleField.text, descriptionField.text, selectedCategoryId)
                    } else {
                        taskManager.addTask(titleField.text, descriptionField.text)
                    }

                    // 如果安排了时间
                    if (scheduleCheckBox.checked) {
                        var startTime = new Date()
                        startTime.setHours(startHourTumbler.currentIndex, startMinuteTumbler.currentIndex, 0, 0)
                        var endTime = new Date()
                        endTime.setHours(endHourTumbler.currentIndex, endMinuteTumbler.currentIndex, 0, 0)

                        var tasks = taskManager.tasks
                        if (tasks.length > 0) {
                            var newTask = tasks[tasks.length - 1]
                            taskManager.scheduleTask(newTask.id, startTime, endTime)

                            // 设置提醒
                            if (reminderCheckBox.checked) {
                                var reminderTime = new Date(startTime)
                                reminderTime.setMinutes(reminderTime.getMinutes() - reminderAdvanceSpinBox.value)
                                taskManager.setTaskReminder(newTask.id, reminderTime)
                            }
                        }
                    }

                    taskCreatorDialog.close()
                    resetForm()
                }

                scale: pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }

    // 重置表单
    function resetForm() {
        titleField.text = ""
        descriptionField.text = ""
        prioritySelector.currentIndex = 0
        colorSelector.currentIndex = 0
        categoryComboBox.currentIndex = 0
        selectedCategoryId = ""
        scheduleCheckBox.checked = false
        reminderCheckBox.checked = false
        startHourTumbler.currentIndex = new Date().getHours()
        startMinuteTumbler.currentIndex = 0
        endHourTumbler.currentIndex = (new Date().getHours() + 1) % 24
        endMinuteTumbler.currentIndex = 0
        reminderHourSpinBox.value = new Date().getHours()
        reminderMinuteSpinBox.value = 0
        reminderAdvanceSpinBox.value = 15
    }

    // 打开对话框时重置
    onOpened: {
        resetForm()
        titleField.forceActiveFocus()
    }
}