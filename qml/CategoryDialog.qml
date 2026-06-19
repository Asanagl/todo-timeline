import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: categoryDialog
    title: "管理分类"
    modal: true
    anchors.centerIn: parent
    width: 400
    height: 450

    property string editingCategoryId: ""

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

        // 新建分类区域
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Label {
                text: "新建分类"
                font.bold: true
                font.pixelSize: 14
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                TextField {
                    id: newCategoryNameField
                    Layout.fillWidth: true
                    placeholderText: "分类名称..."
                    font.pixelSize: 14
                    maximumLength: 50

                    background: Rectangle {
                        radius: 8
                        border.color: newCategoryNameField.activeFocus ? "#2196F3" : "#e0e0e0"
                        border.width: newCategoryNameField.activeFocus ? 2 : 1
                    }
                }

                // 颜色选择
                Rectangle {
                    id: newCategoryColorPreview
                    width: 36
                    height: 36
                    radius: 18
                    color: newCategoryColorSelector.currentIndex >= 0 ? 
                        ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"][newCategoryColorSelector.currentIndex] : "#4A90D9"
                    border.color: Material.theme === Material.Dark ? "#616161" : "#ccc"
                    border.width: 1

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: newCategoryColorSelector.visible = !newCategoryColorSelector.visible
                    }
                }

                Button {
                    text: "添加"
                    Material.background: Material.accent
                    Material.foreground: "white"
                    enabled: newCategoryNameField.text.trim().length > 0
                    onClicked: {
                        var colors = ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]
                        taskManager.addCategory(newCategoryNameField.text.trim(), colors[newCategoryColorSelector.currentIndex])
                        newCategoryNameField.text = ""
                        newCategoryColorSelector.currentIndex = 0
                    }
                }
            }

            // 颜色选择器弹出
            Flow {
                id: newCategoryColorSelector
                visible: false
                Layout.fillWidth: true
                spacing: 8

                property int currentIndex: 0

                Repeater {
                    model: ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]

                    delegate: Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: modelData
                        border.color: newCategoryColorSelector.currentIndex === index ? "white" : "transparent"
                        border.width: 2

                        Rectangle {
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            radius: 6
                            color: "white"
                            visible: newCategoryColorSelector.currentIndex === index
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                newCategoryColorSelector.currentIndex = index
                                newCategoryColorSelector.visible = false
                            }
                        }
                    }
                }
            }
        }

        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Material.theme === Material.Dark ? "#424242" : "#e0e0e0"
        }

        // 分类列表
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            Label {
                text: "现有分类"
                font.bold: true
                font.pixelSize: 14
            }

            ListView {
                id: categoryListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 8
                model: taskManager.categories

                delegate: Rectangle {
                    width: categoryListView.width
                    height: 50
                    radius: 8
                    color: Material.theme === Material.Dark ? "#424242" : "#f5f5f5"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12

                        // 分类颜色指示
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: modelData.color
                        }

                        Label {
                            text: modelData.name
                            font.pixelSize: 14
                            Layout.fillWidth: true
                        }

                        Label {
                            text: modelData.taskCount + " 个任务"
                            font.pixelSize: 12
                            color: Material.theme === Material.Dark ? "#aaa" : "#666"
                        }

                        // 编辑按钮
                        ToolButton {
                            icon.source: "qrc:/icons/edit.svg"
                            icon.width: 16
                            icon.height: 16
                            onClicked: {
                                editingCategoryId = modelData.id
                                editCategoryNameField.text = modelData.name
                                editCategoryDialog.open()
                            }
                        }

                        // 删除按钮
                        ToolButton {
                            icon.source: "qrc:/icons/delete.svg"
                            icon.width: 16
                            icon.height: 16
                            Material.foreground: Material.Red
                            onClicked: {
                                deleteCategoryConfirm.deleteCategoryId = modelData.id
                                deleteCategoryConfirm.open()
                            }
                        }
                    }
                }

                // 空状态
                Label {
                    anchors.centerIn: parent
                    text: "暂无分类\n点击上方添加新分类"
                    horizontalAlignment: Text.AlignHCenter
                    color: "#9e9e9e"
                    font.pixelSize: 14
                    visible: taskManager.categories.length === 0
                }
            }
        }

        // 关闭按钮
        Button {
            text: "关闭"
            Layout.alignment: Qt.AlignRight
            flat: true
            onClicked: categoryDialog.close()
        }
    }

    // 编辑分类对话框
    Dialog {
        id: editCategoryDialog
        title: "编辑分类"
        modal: true
        anchors.centerIn: parent
        width: 300
        height: 200

        property string categoryId: editingCategoryId

        ColumnLayout {
            spacing: 16

            TextField {
                id: editCategoryNameField
                Layout.fillWidth: true
                placeholderText: "分类名称..."
                font.pixelSize: 14
                maximumLength: 50
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]

                    delegate: Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: modelData
                        border.color: editCategoryColorSelector.currentIndex === index ? "white" : "transparent"
                        border.width: 2

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: editCategoryColorSelector.currentIndex = index
                        }
                    }
                }

                Item { id: editCategoryColorSelector; property int currentIndex: 0; visible: false }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "取消"
                    flat: true
                    onClicked: editCategoryDialog.close()
                }

                Button {
                    text: "保存"
                    Material.background: Material.accent
                    Material.foreground: "white"
                    onClicked: {
                        var colors = ["#4A90D9", "#4CAF50", "#FF9800", "#F44336", "#9C27B0", "#00BCD4"]
                        taskManager.updateCategory(editingCategoryId, editCategoryNameField.text.trim(), colors[editCategoryColorSelector.currentIndex])
                        editCategoryDialog.close()
                    }
                }
            }
        }
    }

    // 删除确认对话框
    Dialog {
        id: deleteCategoryConfirm
        title: "确认删除"
        modal: true
        anchors.centerIn: parent
        width: 280
        height: 150

        property string deleteCategoryId: ""

        ColumnLayout {
            spacing: 16

            Label {
                text: "确定要删除此分类吗？\n该分类下的任务将变为无分类状态。"
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Button {
                    text: "取消"
                    flat: true
                    onClicked: deleteCategoryConfirm.close()
                }

                Button {
                    text: "删除"
                    Material.background: Material.Red
                    Material.foreground: "white"
                    onClicked: {
                        taskManager.removeCategory(deleteCategoryConfirm.deleteCategoryId)
                        deleteCategoryConfirm.close()
                    }
                }
            }
        }
    }
}