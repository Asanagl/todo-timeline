import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Rectangle {
    id: taskItemRoot
    height: 96
    radius: C.radiusLarge
    color: Material.theme === Material.Dark ? C.colorSurfaceDark : C.colorSurfaceLight
    border.color: task.completed
        ? C.colorSuccess
        : (Material.theme === Material.Dark ? C.colorBorderDark : C.colorBorderLight)
    border.width: task.completed ? 2 : 1

    property var task: null
    property bool isExpanded: false
    property var taskEditorDialog: null
    property var deleteConfirmDialog: null

    function priorityColor(priority) {
        switch (priority) {
        case 0: return C.colorSuccess
        case 1: return C.colorWarning
        case 2: return C.colorDanger
        default: return C.colorSuccess
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: C.paddingLarge
        spacing: C.spacingLarge

        CheckBox {
            id: completionCheckBox
            checked: taskItemRoot.task.completed
            Material.accent: C.colorSuccess
            Layout.alignment: Qt.AlignVCenter

            onToggled: {
                taskManager.toggleTaskCompletion(taskItemRoot.task.id)
                if (checked) completionAnimation.start()
            }

            SequentialAnimation {
                id: completionAnimation
                ScaleAnimator {
                    target: completionCheckBox
                    from: 1.0
                    to: 1.25
                    duration: C.animDurationNormal
                }
                ScaleAnimator {
                    target: completionCheckBox
                    from: 1.25
                    to: 1.0
                    duration: C.animDurationNormal
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: C.spacingSmall

            Label {
                id: titleLabel
                text: taskItemRoot.task.title
                font.pixelSize: C.fontSizeTitle
                font.bold: true
                font.strikeout: taskItemRoot.task.completed
                color: taskItemRoot.task.completed ? C.colorTextMuted : (Material.theme === Material.Dark ? C.colorTextLight : C.colorTextDark)
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Label {
                id: descriptionLabel
                text: taskItemRoot.task.description || "暂无描述"
                font.pixelSize: C.fontSizeMedium
                color: Material.theme === Material.Dark ? C.colorTextDisabled : C.colorTextSecondary
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: taskItemRoot.isExpanded
                opacity: visible ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: C.animDurationSlow }
                }
            }

            RowLayout {
                spacing: C.spacingMedium
                visible: taskItemRoot.task.scheduled

                Label {
                    text: "\uD83D\uDD50"
                    font.pixelSize: C.fontSizeSmall
                }

                Label {
                    text: Qt.formatTime(taskItemRoot.task.startTime, "HH:mm") + " - " + Qt.formatTime(taskItemRoot.task.endTime, "HH:mm")
                    font.pixelSize: C.fontSizeSmall
                    color: C.colorPrimary
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 5
            Layout.preferredHeight: taskItemRoot.height - 28
            radius: 3
            color: priorityColor(taskItemRoot.task.priority)
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: C.spacingSmall
            Layout.alignment: Qt.AlignVCenter

            RoundButton {
                icon.source: "qrc:/icons/edit.svg"
                icon.width: 20
                icon.height: 20
                flat: true
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                onClicked: {
                    if (taskItemRoot.taskEditorDialog) {
                        taskItemRoot.taskEditorDialog.openEditor(taskItemRoot.task)
                    }
                }
            }

            RoundButton {
                icon.source: "qrc:/icons/delete.svg"
                icon.width: 20
                icon.height: 20
                flat: true
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                Material.foreground: C.colorDanger
                onClicked: {
                    if (taskItemRoot.deleteConfirmDialog) {
                        taskItemRoot.deleteConfirmDialog.confirmDelete(taskItemRoot.task.id, taskItemRoot.task.title)
                    }
                }
            }
        }
    }
}
