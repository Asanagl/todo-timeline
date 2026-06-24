import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Dialog {
    id: categoryDialog
    title: "管理分类"
    modal: true
    anchors.centerIn: parent
    width: C.dialogWidthCategory

    property string editingCategoryId: ""

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

    component FormTextField: TextField {
        Layout.fillWidth: true
        Layout.preferredHeight: C.heightLarge
        font.pixelSize: C.fontSizeLarge
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

    contentItem: ColumnLayout {
        spacing: C.spacingXXLarge
        anchors.margins: C.paddingLarge

        // 新建分类区域
        ColumnLayout {
            Layout.fillWidth: true
            spacing: C.spacingLarge

            Label {
                text: "新建分类"
                font.bold: true
                font.pixelSize: C.fontSizeLarge
                color: themeManager.textColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

                FormTextField {
                    id: newCategoryNameField
                    placeholderText: "分类名称..."
                    maximumLength: 50
                }

                Rectangle {
                    id: newCategoryColorPreview
                    Layout.preferredWidth: C.heightMedium
                    Layout.preferredHeight: C.heightMedium
                    radius: C.heightMedium / 2
                    color: newCategoryColorSelector.currentIndex >= 0
                        ? C.taskColors[newCategoryColorSelector.currentIndex]
                        : themeManager.primaryColor
                    border.color: themeManager.borderColor
                    border.width: 1

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: newCategoryColorSelector.visible = !newCategoryColorSelector.visible
                    }
                }

                Button {
                    text: "添加"
                    Material.background: themeManager.primaryColor
                    Material.foreground: "white"
                    Layout.preferredHeight: C.heightLarge
                    enabled: newCategoryNameField.text.trim().length > 0
                    onClicked: {
                        taskManager.addCategory(newCategoryNameField.text.trim(),
                                                C.taskColors[newCategoryColorSelector.currentIndex])
                        newCategoryNameField.text = ""
                        newCategoryColorSelector.currentIndex = 0
                    }
                }
            }

            Flow {
                id: newCategoryColorSelector
                visible: false
                Layout.fillWidth: true
                spacing: C.spacingMedium

                property int currentIndex: 0

                Repeater {
                    model: C.taskColors
                    delegate: ColorCircleSmall {
                        circleColor: modelData
                        selector: newCategoryColorSelector
                    }
                }
            }
        }

        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: themeManager.borderColor
        }

        // 分类列表
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: C.spacingLarge

            Label {
                text: "现有分类"
                font.bold: true
                font.pixelSize: C.fontSizeLarge
                color: themeManager.textColor
            }

            ListView {
                id: categoryListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 250
                clip: true
                spacing: C.spacingMedium
                model: taskManager.categories

                delegate: Rectangle {
                    required property int index
                    required property var modelData

                    height: C.heightXLarge
                    radius: C.radiusMedium
                    color: themeManager.backgroundColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: C.paddingLarge
                        anchors.rightMargin: C.paddingLarge
                        spacing: C.spacingLarge

                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            radius: 12
                            color: modelData.color
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Label {
                            text: modelData.name
                            font.pixelSize: C.fontSizeLarge
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            color: themeManager.textColor
                        }

                        Label {
                            text: modelData.taskCount + " 个任务"
                            font.pixelSize: C.fontSizeSmall
                            color: C.colorTextSecondary
                            Layout.alignment: Qt.AlignVCenter
                        }

                        RowLayout {
                            spacing: C.spacingSmall
                            Layout.alignment: Qt.AlignVCenter

                            ToolButton {
                                icon.source: "qrc:/icons/edit.svg"
                                icon.width: 18
                                icon.height: 18
                                onClicked: {
                                    editingCategoryId = modelData.id
                                    editCategoryNameField.text = modelData.name
                                    var colorIdx = C.taskColors.indexOf(modelData.color)
                                    editCategoryColorSelector.currentIndex = colorIdx >= 0 ? colorIdx : 0
                                    editCategoryDialog.open()
                                }
                            }

                            ToolButton {
                                icon.source: "qrc:/icons/delete.svg"
                                icon.width: 18
                                icon.height: 18
                                Material.foreground: themeManager.dangerColor
                                onClicked: {
                                    deleteCategoryConfirm.deleteCategoryId = modelData.id
                                    deleteCategoryConfirm.open()
                                }
                            }
                        }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: "暂无分类\n点击上方添加新分类"
                    horizontalAlignment: Text.AlignHCenter
                    color: C.colorTextMuted
                    font.pixelSize: C.fontSizeLarge
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
        width: C.dialogWidthMedium

        contentItem: ColumnLayout {
            spacing: C.spacingXLarge

            FormTextField {
                id: editCategoryNameField
                placeholderText: "分类名称..."
                maximumLength: 50
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingMedium

                Repeater {
                    model: C.taskColors
                    delegate: ColorCircleSmall {
                        circleColor: modelData
                        selector: editCategoryColorSelector
                    }
                }

                Item { id: editCategoryColorSelector; property int currentIndex: 0; visible: false }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

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
                        taskManager.updateCategory(editingCategoryId,
                                                   editCategoryNameField.text.trim(),
                                                   C.taskColors[editCategoryColorSelector.currentIndex])
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
        width: C.dialogWidthSmall

        property string deleteCategoryId: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: C.spacingXLarge

            Label {
                text: "确定要删除此分类吗？\n该分类下的任务将变为无分类状态。"
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: C.spacingLarge

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
