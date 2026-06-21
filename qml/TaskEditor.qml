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

    property string taskId: ""
    property string taskTitle: ""
    property string taskDescription: ""
    property int taskPriority: 0
    property string taskColor: C.colorPrimary
    property string taskCategory: ""

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
        color: Material.theme === Material.Dark ? C.colorTextLight : C.colorTextDark
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
            color: Material.theme === Material.Dark ? C.colorSurfaceDark : C.colorSurfaceLight
            border.color: parent.activeFocus ? C.colorPrimary : (Material.theme === Material.Dark ? C.colorBorderDark : C.colorBorderLight)
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
            color: Material.theme === Material.Dark ? C.colorSurfaceDark : C.colorSurfaceLight
            border.color: parent.activeFocus ? C.colorPrimary : (Material.theme === Material.Dark ? C.colorBorderDark : C.colorBorderLight)
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
        titleField.text = task.title
        descriptionField.text = task.description
        prioritySelector.currentIndex = task.priority
        var colorIdx = C.taskColors.indexOf(task.color)
        colorSelector.currentIndex = colorIdx >= 0 ? colorIdx : 0
        open()
    }

    contentItem: ColumnLayout {
        spacing: C.spacingXXLarge
        anchors.margins: C.paddingLarge

        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingMedium

            FormLabel { text: "任务标题 *" }

            FormTextField {
                id: titleField
                placeholderText: "输入任务标题..."
                text: taskEditorDialog.taskTitle
                onAccepted: {
                    if (saveButton.enabled) saveButton.clicked()
                }
            }
        }

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
                Material.background: C.colorPrimary
                Material.foreground: "white"
                Layout.fillWidth: true
                Layout.preferredHeight: C.heightLarge
                enabled: titleField.text.trim().length > 0
                highlighted: true

                onClicked: {
                    taskManager.updateTaskFull(
                        taskEditorDialog.taskId,
                        titleField.text,
                        descriptionField.text,
                        prioritySelector.currentIndex,
                        C.taskColors[colorSelector.currentIndex],
                        taskEditorDialog.taskCategory
                    )
                    taskEditorDialog.close()
                    notification.show("任务已更新: " + titleField.text)
                }
            }
        }
    }
}
