import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Rectangle {
    id: taskItemRoot
    height: taskItemRoot.isExpanded ? 120 : 96
    radius: C.radiusLarge
    // 亚克力半透明背景（性能优先：不实时模糊，仅半透明）
    color: {
        var baseColor = task.completed
            ? (Material.theme === Material.Dark ? C.colorCompletedBgDark : C.colorSuccessBg)
            : themeManager.surfaceColor
        var alpha = themeManager.acrylicEnabled ? themeManager.acrylicOpacity : 1.0
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, alpha)
    }
    border.color: task.completed
        ? themeManager.successColor
        : themeManager.borderColor
    border.width: task.completed ? 2 : 1

    property var task: null
    property bool isExpanded: false
    property var taskEditorDialog: null
    property var deleteConfirmDialog: null

    function priorityColor(priority) {
        switch (priority) {
        case 0: return themeManager.successColor
        case 1: return themeManager.warningColor
        case 2: return themeManager.dangerColor
        default: return themeManager.successColor
        }
    }

    function priorityText(priority) {
        switch (priority) {
        case 0: return "低"
        case 1: return "中"
        case 2: return "高"
        default: return "低"
        }
    }

    function priorityBg(priority) {
        switch (priority) {
        case 0: return C.priorityLabelBgLow
        case 1: return C.priorityLabelBgMedium
        case 2: return C.priorityLabelBgHigh
        default: return C.priorityLabelBgLow
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: C.paddingLarge
        spacing: C.spacingLarge

        CheckBox {
            id: completionCheckBox
            checked: taskItemRoot.task.completed
            Material.accent: themeManager.successColor
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

            // 标题行：标题 + 优先级标签
            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingMedium

                Label {
                    text: taskItemRoot.task.title
                    font.pixelSize: C.fontSizeTitle
                    font.bold: true
                    font.strikeout: taskItemRoot.task.completed
                    color: taskItemRoot.task.completed ? C.colorTextMuted : themeManager.textColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // 优先级文字标签
                Rectangle {
                    Layout.preferredHeight: C.badgeHeight
                    Layout.preferredWidth: priorityLabel.implicitWidth + C.badgePaddingH * 2
                    radius: C.badgeRadius
                    color: priorityBg(taskItemRoot.task.priority)
                    border.color: priorityColor(taskItemRoot.task.priority)
                    border.width: 1
                    visible: !taskItemRoot.task.completed

                    Label {
                        id: priorityLabel
                        anchors.centerIn: parent
                        text: priorityText(taskItemRoot.task.priority)
                        font.pixelSize: C.badgeFontSize
                        font.bold: true
                        color: priorityColor(taskItemRoot.task.priority)
                    }
                }
            }

            Label {
                id: descriptionLabel
                text: taskItemRoot.task.description
                font.pixelSize: C.fontSizeMedium
                color: Material.theme === Material.Dark ? C.colorTextDisabled : C.colorTextSecondary
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: taskItemRoot.isExpanded && taskItemRoot.task.description.length > 0
                opacity: visible ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: C.animDurationSlow }
                }
            }

            // 时间标签行
            RowLayout {
                spacing: C.spacingSmall
                visible: taskItemRoot.task.scheduled

                Label {
                    text: "时间"
                    font.pixelSize: C.fontSizeMin
                    color: C.colorTextMuted
                }

                Label {
                    text: Qt.formatTime(taskItemRoot.task.startTime, "HH:mm") + " - " + Qt.formatTime(taskItemRoot.task.endTime, "HH:mm")
                    font.pixelSize: C.fontSizeSmall
                    color: themeManager.primaryColor
                    font.bold: true
                }

                // 提醒标识
                Rectangle {
                    visible: taskItemRoot.task.hasReminder
                    Layout.preferredHeight: C.badgeHeight - 4
                    Layout.preferredWidth: reminderIcon.implicitWidth + C.badgePaddingH
                    radius: (C.badgeHeight - 4) / 2
                    color: C.colorDangerBg
                    border.color: themeManager.dangerColor
                    border.width: 1

                    Label {
                        id: reminderIcon
                        anchors.centerIn: parent
                        text: "提醒"
                        font.pixelSize: C.fontSizeMin
                        font.bold: true
                        color: themeManager.dangerColor
                    }
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
                Material.foreground: themeManager.dangerColor
                onClicked: {
                    if (taskItemRoot.deleteConfirmDialog) {
                        taskItemRoot.deleteConfirmDialog.confirmDelete(taskItemRoot.task.id, taskItemRoot.task.title)
                    }
                }
            }
        }
    }
}
