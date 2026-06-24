import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "AppConstants.js" as C

Rectangle {
    id: timelineRoot
    color: themeManager.backgroundColor

    property date currentDate: new Date()
    readonly property string currentDateStr: Qt.formatDate(currentDate, "yyyyMMdd")
    readonly property string todayStr: Qt.formatDate(new Date(), "yyyyMMdd")
    readonly property int hourHeight: 80
    property int currentHour: new Date().getHours()

    function getCurrentTimeY() {
        var now = new Date()
        if (Qt.formatDate(now, "yyyyMMdd") === todayStr) {
            return (now.getHours() * hourHeight) + (now.getMinutes() / 60 * hourHeight)
        }
        return -100
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 日期导航栏（亚克力半透明效果）
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: C.heightXLarge + 16
            color: Qt.rgba(
                themeManager.surfaceColor.r,
                themeManager.surfaceColor.g,
                themeManager.surfaceColor.b,
                themeManager.acrylicEnabled ? themeManager.acrylicOpacity : 1.0
            )
            border.color: themeManager.borderColor
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: C.paddingLarge
                anchors.rightMargin: C.paddingLarge

                RoundButton {
                    icon.source: "qrc:/icons/chevron_left.svg"
                    flat: true
                    onClicked: timelineRoot.shiftDate(-1)
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(timelineRoot.currentDate, "yyyy年MM月dd日 dddd")
                    font.pixelSize: C.fontSizeHeader
                    font.bold: true
                    color: themeManager.textColor
                }

                RoundButton {
                    icon.source: "qrc:/icons/chevron_right.svg"
                    flat: true
                    onClicked: timelineRoot.shiftDate(1)
                }

                Button {
                    text: "今天"
                    flat: true
                    visible: timelineRoot.currentDateStr !== timelineRoot.todayStr
                    onClicked: timelineRoot.setDate(new Date())
                }
            }
        }

        // 时间轴主体
        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: timelineListView
                model: timelineModel
                spacing: 0

                header: Item {
                    width: timelineListView.width
                    height: 1
                }

                delegate: Rectangle {
                    id: hourDelegate
                    width: timelineListView.width
                    height: hourHeight
                    color: hourDelegate.isCurrentHour ? C.colorPrimaryBg : (Material.theme === Material.Dark ?
                        (hourDelegate.index % 2 === 0 ? C.colorSurfaceDark : C.colorStripeDark) :
                        (hourDelegate.index % 2 === 0 ? C.colorSurfaceLight : C.colorStripeLight))

                    required property int index
                    required property string timeString
                    property int hour: index
                    property bool isCurrentHour: timelineRoot.currentDateStr === timelineRoot.todayStr && timelineRoot.currentHour === hour
                    property color baseColor: hourDelegate.isCurrentHour ? C.colorPrimaryBg : (Material.theme === Material.Dark ?
                        (hourDelegate.index % 2 === 0 ? C.colorSurfaceDark : C.colorStripeDark) :
                        (hourDelegate.index % 2 === 0 ? C.colorSurfaceLight : C.colorStripeLight))

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: C.paddingLarge
                        anchors.rightMargin: C.paddingLarge
                        spacing: C.paddingLarge

                        Label {
                            text: hourDelegate.timeString
                            font.pixelSize: C.fontSizeLarge
                            font.bold: hourDelegate.isCurrentHour
                            color: hourDelegate.isCurrentHour ? themeManager.primaryColor : C.colorTextSecondary
                            Layout.preferredWidth: 60
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: hourDelegate.isCurrentHour ? themeManager.primaryColor : themeManager.borderColor
                        }
                    }

                    Rectangle {
                        id: currentHourIndicator
                        visible: hourDelegate.isCurrentHour
                        anchors.left: parent.left
                        anchors.leftMargin: 86
                        anchors.verticalCenter: parent.verticalCenter
                        width: 12
                        height: 12
                        radius: 6
                        color: themeManager.primaryColor

                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            running: hourDelegate.isCurrentHour && currentHourIndicator.visible
                            NumberAnimation { from: 1.0; to: 1.5; duration: 1000; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 1.5; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                        }
                    }

                    DropArea {
                        id: dropArea
                        anchors.fill: parent
                        anchors.leftMargin: 100

                        property bool isHovered: false

                        onDropped: function(drop) {
                            // qmllint disable missing-property
                            var draggedTask = drop.source.task
                            // qmllint enable missing-property
                            if (draggedTask && draggedTask.id) {
                                var startTime = new Date(timelineRoot.currentDate)
                                startTime.setHours(hourDelegate.hour, 0, 0, 0)
                                var endTime = new Date(startTime.getTime() + 3600000)
                                taskManager.scheduleTask(draggedTask.id, startTime, endTime)
                                notification.show("任务已安排到 " + Qt.formatTime(startTime, "HH:mm"))
                            }
                            isHovered = false
                        }

                        onEntered: {
                            isHovered = true
                            hourDelegate.color = C.colorPrimaryBg
                            dropIndicator.visible = true
                        }

                        onExited: {
                            isHovered = false
                            hourDelegate.color = hourDelegate.baseColor
                            dropIndicator.visible = false
                        }
                    }

                    Rectangle {
                        id: dropIndicator
                        visible: false
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.right: parent.right
                        anchors.rightMargin: C.paddingLarge
                        anchors.verticalCenter: parent.verticalCenter
                        height: C.taskBlockHeight
                        radius: C.radiusSmall
                        color: Qt.rgba(0x25/255, 0x63/255, 0xEB/255, 0.2)
                        border.color: themeManager.primaryColor
                        border.width: 2

                        Label {
                            anchors.centerIn: parent
                            text: "放置到 " + hourDelegate.timeString
                            font.pixelSize: C.fontSizeSmall
                            color: themeManager.primaryColor
                            font.bold: true
                        }

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: dropIndicator.visible
                            NumberAnimation { from: 1.0; to: 0.5; duration: 600; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 0.5; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                        }
                    }

                    Repeater {
                        model: {
                            taskManager.scheduledTasksVersion
                            return taskManager.tasksForHour(timelineRoot.currentDate, hourDelegate.hour)
                        }

                        Rectangle {
                            required property int index
                            required property var modelData

                            anchors.left: parent.left
                            anchors.leftMargin: 100
                            anchors.right: parent.right
                            anchors.rightMargin: C.paddingLarge
                            anchors.top: parent.top
                            anchors.topMargin: 4 + index * (C.taskBlockHeight + C.taskBlockSpacing)
                            height: C.taskBlockHeight
                            radius: C.radiusSmall
                            color: modelData.color || themeManager.primaryColor
                            opacity: 0.9
                            border.color: Qt.darker(modelData.color || themeManager.primaryColor, 1.3)
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: C.spacingMedium
                                anchors.rightMargin: C.spacingMedium
                                spacing: C.spacingSmall

                                Label {
                                    text: Qt.formatTime(modelData.startTime, "HH:mm")
                                    color: C.colorTextOnAccent
                                    font.pixelSize: C.fontSizeSmall
                                    font.bold: true
                                    Layout.preferredWidth: 38
                                }

                                Rectangle {
                                    Layout.preferredWidth: 1
                                    Layout.fillHeight: true
                                    Layout.topMargin: 4
                                    Layout.bottomMargin: 4
                                    color: Qt.rgba(1, 1, 1, 0.4)
                                }

                                Label {
                                    text: modelData.title
                                    color: C.colorTextOnAccent
                                    font.pixelSize: C.fontSizeSmall
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }

                // 当前时间线
                Item {
                    id: currentTimeLine
                    parent: timelineListView.contentItem
                    x: 0
                    y: getCurrentTimeY()
                    width: timelineListView.width
                    height: 2
                    visible: y >= 0

                    Rectangle {
                        anchors.fill: parent
                        color: themeManager.dangerColor
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 70
                        anchors.verticalCenter: parent.verticalCenter
                        width: 52
                        height: 22
                        radius: C.radiusSmall
                        color: themeManager.dangerColor

                        Label {
                            anchors.centerIn: parent
                            text: Qt.formatTime(new Date(), "HH:mm")
                            color: C.colorTextOnAccent
                            font.pixelSize: C.fontSizeSmall
                        }
                    }
                }
            }
        }
    }

    // 空状态提示（覆盖在 ScrollView 上，当无安排任务时显示）
    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40
        spacing: C.spacingMedium
        visible: taskManager.scheduledTasks.length === 0
        z: 10

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 64
            Layout.preferredHeight: 64
            radius: 32
            color: themeManager.surfaceColor
            border.color: themeManager.borderColor
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "○"
                font.pixelSize: 32
                color: C.colorTextMuted
            }
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "暂无安排的任务"
            color: C.colorTextSecondary
            font.pixelSize: C.fontSizeTitle
            font.bold: true
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "从左侧拖拽任务到时间轴"
            color: C.colorTextMuted
            font.pixelSize: C.fontSizeMedium
        }
    }

    function shiftDate(days) {
        var d = new Date(currentDate.getTime() + days * 86400000)
        setDate(d)
    }

    function setDate(date) {
        currentDate = date
        timelineModel.currentDate = date
    }

    function addTaskToTimeline(task) {
        timelineListView.forceLayout()
    }

    function scrollToCurrentTime() {
        var now = new Date()
        var y = (now.getHours() * hourHeight) + (now.getMinutes() / 60 * hourHeight)
        timelineListView.contentY = y - timelineListView.height / 2
    }

    Component.onCompleted: {
        timelineModel.currentDate = currentDate
        Qt.callLater(scrollToCurrentTime)
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            currentHour = new Date().getHours()
            currentTimeLine.y = getCurrentTimeY()
        }
    }
}
