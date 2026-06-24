import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Dialog {
    id: deleteConfirmDialog
    title: "确认删除"
    modal: true
    anchors.centerIn: parent
    width: C.dialogWidthLarge

    property string taskId: ""
    property string taskTitle: ""

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
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: C.animDurationEnter }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: C.animDurationEnter; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: C.animDurationSlow }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; duration: C.animDurationSlow }
    }

    function confirmDelete(taskId, taskTitle) {
        deleteConfirmDialog.taskId = taskId
        deleteConfirmDialog.taskTitle = taskTitle
        open()
    }

    contentItem: ColumnLayout {
        spacing: C.spacingXXLarge
        anchors.margins: C.paddingLarge

        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingLarge

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: C.heightXLarge
                Layout.preferredHeight: C.heightXLarge
                radius: C.heightXLarge / 2
                color: C.colorWarningBg

                Label {
                    anchors.centerIn: parent
                    text: "!"
                    font.pixelSize: 24
                    font.bold: true
                    color: themeManager.warningColor
                }
            }

            Label {
                Layout.fillWidth: true
                text: "确定要删除任务吗？"
                font.pixelSize: C.fontSizeTitle
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                Layout.fillWidth: true
                text: "\"" + deleteConfirmDialog.taskTitle + "\""
                font.pixelSize: C.fontSizeLarge
                color: C.colorTextSecondary
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Label {
                Layout.fillWidth: true
                text: "此操作无法撤销"
                font.pixelSize: C.fontSizeSmall
                color: themeManager.dangerColor
                horizontalAlignment: Text.AlignHCenter
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: C.spacingLarge

            Button {
                text: "取消"
                flat: true
                Layout.fillWidth: true
                onClicked: deleteConfirmDialog.close()
            }

            Button {
                text: "删除"
                Material.background: themeManager.dangerColor
                Material.foreground: "white"
                Layout.fillWidth: true
                Layout.preferredHeight: C.heightLarge

                onClicked: {
                    taskManager.removeTask(deleteConfirmDialog.taskId)
                    deleteConfirmDialog.close()
                    notification.show("任务已删除: " + deleteConfirmDialog.taskTitle)
                }
            }
        }
    }
}
