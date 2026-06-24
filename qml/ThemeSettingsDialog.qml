import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import "AppConstants.js" as C

Dialog {
    id: themeDialog
    title: "主题设置"
    modal: true
    anchors.centerIn: parent
    width: 560
    height: 620

    // 亚克力半透明背景（与其他对话框一致）
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

    // ===== 快照/恢复机制 =====
    property var snapshot: ({})

    function takeSnapshot() {
        snapshot = {
            primaryColor: themeManager.primaryColor,
            accentColor: themeManager.accentColor,
            successColor: themeManager.successColor,
            warningColor: themeManager.warningColor,
            dangerColor: themeManager.dangerColor,
            backgroundColor: themeManager.backgroundColor,
            surfaceColor: themeManager.surfaceColor,
            textColor: themeManager.textColor,
            borderColor: themeManager.borderColor,
            darkModeEnabled: themeManager.darkModeEnabled,
            acrylicEnabled: themeManager.acrylicEnabled,
            acrylicOpacity: themeManager.acrylicOpacity
        }
    }

    function restoreSnapshot() {
        themeManager.setPrimaryColor(snapshot.primaryColor)
        themeManager.setAccentColor(snapshot.accentColor)
        themeManager.setSuccessColor(snapshot.successColor)
        themeManager.setWarningColor(snapshot.warningColor)
        themeManager.setDangerColor(snapshot.dangerColor)
        themeManager.setBackgroundColor(snapshot.backgroundColor)
        themeManager.setSurfaceColor(snapshot.surfaceColor)
        themeManager.setTextColor(snapshot.textColor)
        themeManager.setBorderColor(snapshot.borderColor)
        themeManager.setDarkModeEnabled(snapshot.darkModeEnabled)
        themeManager.setAcrylicEnabled(snapshot.acrylicEnabled)
        themeManager.setAcrylicOpacity(snapshot.acrylicOpacity)
    }

    onOpened: takeSnapshot()

    // ===== 颜色定义模型 =====
    property var colorDefinitions: [
        { label: "主色调", property: "primaryColor", note: "" },
        { label: "辅助色", property: "accentColor", note: "" },
        { label: "成功色", property: "successColor", note: "" },
        { label: "警告色", property: "warningColor", note: "" },
        { label: "危险色", property: "dangerColor", note: "" },
        { label: "背景色", property: "backgroundColor", note: "（仅浅色模式）" },
        { label: "表面色", property: "surfaceColor", note: "（仅浅色模式）" },
        { label: "文字色", property: "textColor", note: "（仅浅色模式）" },
        { label: "边框色", property: "borderColor", note: "（仅浅色模式）" }
    ]

    // ===== ColorDialog =====
    ColorDialog {
        id: colorDialog
        property string targetProperty: ""

        function openForColor(propName) {
            targetProperty = propName
            var currentColor = themeManager[propName]
            selectedColor = currentColor
            open()
        }

        onAccepted: {
            if (targetProperty !== "") {
                var hexColor = "#" +
                    ("00" + Math.round(selectedColor.r * 255).toString(16)).slice(-2).toUpperCase() +
                    ("00" + Math.round(selectedColor.g * 255).toString(16)).slice(-2).toUpperCase() +
                    ("00" + Math.round(selectedColor.b * 255).toString(16)).slice(-2).toUpperCase()
                var setterName = "set" + targetProperty.charAt(0).toUpperCase() + targetProperty.slice(1)
                themeManager[setterName](hexColor)
                targetProperty = ""
            }
        }
    }

    // ===== 内容区 =====
    contentItem: ColumnLayout {
        spacing: C.spacingLarge
        anchors.margins: C.paddingLarge

        // ===== TabBar =====
        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton {
                text: "预设主题"
                width: implicitWidth
            }
            TabButton {
                text: "自定义配色"
                width: implicitWidth
            }
        }

        // ===== StackLayout =====
        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // ===== Tab 1: 预设主题 =====
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridView {
                    id: presetGrid
                    width: parent.width
                    height: parent.height
                    cellWidth: (width - C.spacingMedium) / 2
                    cellHeight: 140
                    model: themeManager.presetNames()
                    spacing: C.spacingMedium

                    delegate: Rectangle {
                        required property int index
                        required property var modelData

                        width: presetGrid.cellWidth - C.spacingMedium
                        height: presetGrid.cellHeight - C.spacingMedium
                        radius: C.radiusMedium
                        color: themeManager.surfaceColor
                        border.color: isSelected ? themeManager.primaryColor : themeManager.borderColor
                        border.width: isSelected ? 2 : 1

                        property bool isSelected: themeManager.primaryColor === themeManager.presetColors(index).primaryColor

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: themeManager.applyPreset(index)
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: C.paddingMedium
                            spacing: C.spacingSmall

                            // 预设名称
                            RowLayout {
                                Layout.fillWidth: true

                                Label {
                                    text: modelData
                                    font.pixelSize: C.fontSizeLarge
                                    font.bold: true
                                    color: themeManager.textColor
                                    Layout.fillWidth: true
                                }

                                // 选中指示器
                                Rectangle {
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20
                                    radius: 10
                                    color: isSelected ? themeManager.primaryColor : "transparent"
                                    border.color: isSelected ? "transparent" : themeManager.borderColor
                                    border.width: 1
                                    visible: isSelected

                                    Label {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        color: "#FFFFFF"
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                            }

                            // 颜色色块预览
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                Repeater {
                                    model: [
                                        themeManager.presetColors(index).primaryColor,
                                        themeManager.presetColors(index).accentColor,
                                        themeManager.presetColors(index).successColor,
                                        themeManager.presetColors(index).warningColor,
                                        themeManager.presetColors(index).dangerColor
                                    ]

                                    delegate: Rectangle {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 32
                                        radius: C.radiusSmall
                                        color: modelData
                                        border.color: themeManager.borderColor
                                        border.width: 1
                                    }
                                }
                            }

                            // 底部信息
                            Label {
                                text: isSelected ? "当前主题" : "点击应用"
                                font.pixelSize: C.fontSizeSmall
                                color: isSelected ? themeManager.primaryColor : C.colorTextMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            // ===== Tab 2: 自定义配色 =====
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width
                    spacing: C.spacingMedium

                    // 颜色编辑器列表
                    Repeater {
                        model: themeDialog.colorDefinitions

                        delegate: RowLayout {
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: C.spacingMedium

                            // 标签
                            Label {
                                text: modelData.label
                                font.pixelSize: C.fontSizeLarge
                                color: themeManager.textColor
                                Layout.preferredWidth: 80
                            }

                            // 颜色预览色块（点击打开 ColorDialog）
                            Rectangle {
                                id: colorPreview
                                Layout.preferredWidth: C.heightMedium
                                Layout.preferredHeight: C.heightMedium
                                radius: C.radiusSmall
                                color: themeManager[modelData.property]
                                border.color: themeManager.borderColor
                                border.width: 1

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: colorDialog.openForColor(modelData.property)
                                }
                            }

                            // hex 输入框
                            TextField {
                                id: hexInput
                                Layout.fillWidth: true
                                Layout.preferredHeight: C.heightLarge
                                font.pixelSize: C.fontSizeLarge
                                text: themeManager[modelData.property]
                                placeholderText: "#RRGGBB"
                                maximumLength: 7
                                leftPadding: C.paddingMedium
                                rightPadding: C.paddingMedium
                                verticalAlignment: Text.AlignVCenter

                                background: Rectangle {
                                    radius: C.radiusMedium
                                    color: themeManager.surfaceColor
                                    border.color: parent.activeFocus ? themeManager.primaryColor : themeManager.borderColor
                                    border.width: parent.activeFocus ? 2 : 1
                                }

                                function applyColor() {
                                    var val = text.trim()
                                    if (/^#[0-9A-Fa-f]{6}$/.test(val)) {
                                        var setterName = "set" + modelData.property.charAt(0).toUpperCase() + modelData.property.slice(1)
                                        themeManager[setterName](val.toUpperCase())
                                    } else {
                                        text = themeManager[modelData.property]
                                    }
                                }

                                onEditingFinished: applyColor()
                                onAccepted: applyColor()
                            }

                            // 说明文字（模式感知颜色）
                            Label {
                                text: modelData.note
                                font.pixelSize: C.fontSizeSmall
                                color: C.colorTextMuted
                                visible: modelData.note !== ""
                                Layout.preferredWidth: 80
                            }
                        }
                    }

                    // 分隔线
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: themeManager.borderColor
                        Layout.topMargin: C.spacingSmall
                        Layout.bottomMargin: C.spacingSmall
                    }

                    // 深色模式开关
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: C.spacingMedium

                        Label {
                            text: "深色模式"
                            font.pixelSize: C.fontSizeLarge
                            color: themeManager.textColor
                            Layout.fillWidth: true
                        }

                        Switch {
                            checked: themeManager.darkModeEnabled
                            onCheckedChanged: themeManager.setDarkModeEnabled(checked)
                        }
                    }

                    // 亚克力效果开关
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: C.spacingMedium

                        Label {
                            text: "亚克力效果"
                            font.pixelSize: C.fontSizeLarge
                            color: themeManager.textColor
                            Layout.fillWidth: true
                        }

                        Switch {
                            checked: themeManager.acrylicEnabled
                            onCheckedChanged: themeManager.setAcrylicEnabled(checked)
                        }
                    }

                    // 透明度滑块
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: C.spacingSmall

                        RowLayout {
                            Layout.fillWidth: true

                            Label {
                                text: "透明度"
                                font.pixelSize: C.fontSizeLarge
                                color: themeManager.textColor
                            }

                            Item { Layout.fillWidth: true }

                            Label {
                                text: Math.round(themeManager.acrylicOpacity * 100) + "%"
                                font.pixelSize: C.fontSizeLarge
                                font.bold: true
                                color: themeManager.primaryColor
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            stepSize: 5
                            value: Math.round(themeManager.acrylicOpacity * 100)
                            enabled: themeManager.acrylicEnabled

                            onValueChanged: {
                                if (themeManager.acrylicEnabled) {
                                    themeManager.setAcrylicOpacity(value / 100.0)
                                }
                            }
                        }

                        Label {
                            text: "拖动滑块调整亚克力效果的透明度（对话框最低保持 85% 以确保可读性）"
                            font.pixelSize: C.fontSizeSmall
                            color: C.colorTextMuted
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }

        // ===== 底部按钮栏 =====
        RowLayout {
            Layout.fillWidth: true
            spacing: C.spacingLarge

            Button {
                text: "重置默认"
                flat: true
                onClicked: {
                    themeManager.resetToDefault()
                    takeSnapshot()
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "取消"
                flat: true
                onClicked: {
                    restoreSnapshot()
                    themeDialog.close()
                }
            }

            Button {
                text: "应用"
                Material.background: themeManager.primaryColor
                Material.foreground: "#FFFFFF"
                onClicked: themeDialog.close()
            }
        }
    }
}
