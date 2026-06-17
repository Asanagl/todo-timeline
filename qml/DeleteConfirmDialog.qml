import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: deleteConfirmDialog
    title: "确认删除"
    modal: true
    anchors.centerIn: parent
    width: 360
    height: 220

    property string taskId: ""
    property string taskTitle: ""

    // 动画
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 250 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 250; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 200 }
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; duration: 200 }
    }

    function confirmDelete(taskId, taskTitle) {
        deleteConfirmDialog.taskId = taskId
        deleteConfirmDialog.taskTitle = taskTitle
        open()
    }

    contentItem: ColumnLayout {
        spacing: 20

        // 警告图标和文字
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            // 警告图标
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 48
                height: 48
                radius: 24
                color: "#FFF3E0"

                Label {
                    anchors.centerIn: parent
                    text: "!"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF9800"
                }
            }

            Label {
                Layout.fillWidth: true
                text: "确定要删除任务吗？"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Label {
                Layout.fillWidth: true
                text: "\"" + deleteConfirmDialog.taskTitle + "\""
                font.pixelSize: 14
                color: "#757575"
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Label {
                Layout.fillWidth: true
                text: "此操作无法撤销"
                font.pixelSize: 12
                color: "#F44336"
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // 按钮区域
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                text: "取消"
                flat: true
                Layout.fillWidth: true
                onClicked: deleteConfirmDialog.close()
            }

            Button {
                text: "删除"
                Material.background: "#F44336"
                Material.foreground: "white"
                Layout.fillWidth: true

                onClicked: {
                    taskManager.removeTask(deleteConfirmDialog.taskId)
                    deleteConfirmDialog.close()
                    notification.show("任务已删除: " + deleteConfirmDialog.taskTitle)
                }

                scale: pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }
        }
    }
}
