import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: timelineRoot
    color: Material.theme === Material.Dark ? "#303030" : "#fafafa"

    // 当前显示的日期
    property date currentDate: new Date()
    // 预计算当前日期字符串，避免每个 delegate 重复格式化
    property string currentDateStr: Qt.formatDate(currentDate, "yyyyMMdd")
    // 每小时高度常量，避免硬编码散落各处
    readonly property int hourHeight: 80

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 日期导航栏
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Material.theme === Material.Dark ? "#424242" : "white"
            border.color: Material.theme === Material.Dark ? "#616161" : "#e0e0e0"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                // 前一天按钮
                RoundButton {
                    icon.source: "qrc:/icons/chevron_left.svg"
                    flat: true
                    onClicked: {
                        currentDate = new Date(currentDate.getTime() - 86400000)
                        timelineModel.currentDate = currentDate
                    }
                }

                // 日期显示
                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(currentDate, "yyyy年MM月dd日 dddd")
                    font.pixelSize: 18
                    font.bold: true
                }

                // 后一天按钮
                RoundButton {
                    icon.source: "qrc:/icons/chevron_right.svg"
                    flat: true
                    onClicked: {
                        currentDate = new Date(currentDate.getTime() + 86400000)
                        timelineModel.currentDate = currentDate
                    }
                }

                // 今天按钮
                Button {
                    text: "今天"
                    flat: true
                    visible: Qt.formatDate(currentDate, "yyyyMMdd") !== Qt.formatDate(new Date(), "yyyyMMdd")
                    onClicked: {
                        currentDate = new Date()
                        timelineModel.currentDate = currentDate
                    }
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

                // 当前时间指示器
                header: Item {
                    width: timelineListView.width
                    height: 1
                }

                delegate: Rectangle {
                    id: hourDelegate
                    width: timelineListView.width
                    height: hourHeight
                    color: isCurrentHour ? "#E3F2FD" : (Material.theme === Material.Dark ?
                        (index % 2 === 0 ? "#383838" : "#303030") :
                        (index % 2 === 0 ? "white" : "#fafafa"))

                    property int hour: index
                    // 缓存默认颜色，避免 onExited 重复计算
                    property color baseColor: isCurrentHour ? "#E3F2FD" : (Material.theme === Material.Dark ?
                        (index % 2 === 0 ? "#383838" : "#303030") :
                        (index % 2 === 0 ? "white" : "#fafafa"))

                    // 时间标签
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 16

                        // 时间文字
                        Label {
                            text: timeString
                            font.pixelSize: 14
                            font.bold: isCurrentHour
                            color: isCurrentHour ? "#1976D2" : "#757575"
                            Layout.preferredWidth: 60
                        }

                        // 分隔线
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: isCurrentHour ? "#1976D2" : "#e0e0e0"
                        }
                    }

                    // 当前时间指示器
                    Rectangle {
                        visible: isCurrentHour
                        anchors.left: parent.left
                        anchors.leftMargin: 86
                        anchors.verticalCenter: parent.verticalCenter
                        width: 12
                        height: 12
                        radius: 6
                        color: "#1976D2"

                        // 脉冲动画
                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            running: isCurrentHour
                            NumberAnimation { from: 1.0; to: 1.5; duration: 1000; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 1.5; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                        }
                    }

                    // 拖拽目标区域
                    DropArea {
                        id: dropArea
                        anchors.fill: parent
                        anchors.leftMargin: 100

                        property bool isHovered: false

                        onDropped: function(event) {
                            if (event.source.taskId) {
                                var startTime = new Date(currentDate)
                                startTime.setHours(hour, 0, 0, 0)
                                var endTime = new Date(startTime.getTime() + 3600000) // 默认1小时
                                taskManager.scheduleTask(event.source.taskId, startTime, endTime)
                                notification.show("任务已安排到 " + Qt.formatTime(startTime, "HH:mm"))
                            }
                            isHovered = false
                        }

                        onEntered: {
                            isHovered = true
                            hourDelegate.color = "#BBDEFB"
                            dropIndicator.visible = true
                        }

                        onExited: {
                            isHovered = false
                            hourDelegate.color = hourDelegate.baseColor
                            dropIndicator.visible = false
                        }
                    }

                    // 拖拽放置指示器
                    Rectangle {
                        id: dropIndicator
                        visible: false
                        anchors.left: parent.left
                        anchors.leftMargin: 100
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        height: 24
                        radius: 6
                        color: Qt.rgba(33, 150, 243, 0.2)
                        border.color: "#2196F3"
                        border.width: 2

                        Label {
                            anchors.centerIn: parent
                            text: "放置到 " + timeString
                            font.pixelSize: 12
                            color: "#1976D2"
                            font.bold: true
                        }

                        // 闪烁动画
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: dropIndicator.visible
                            NumberAnimation { from: 1.0; to: 0.5; duration: 600; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 0.5; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
                        }
                    }

                    // 已安排的任务显示 — 使用 currentDateStr 避免重复格式化
                    Repeater {
                        model: {
                            var scheduled = []
                            for (var i = 0; i < taskManager.scheduledTasks.length; i++) {
                                var task = taskManager.scheduledTasks[i]
                                if (task.scheduled && task.startTime && task.endTime) {
                                    if (task.startTime.getHours() === hour &&
                                        Qt.formatDate(task.startTime, "yyyyMMdd") === currentDateStr) {
                                        scheduled.push(task)
                                    }
                                }
                            }
                            return scheduled
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.leftMargin: 100
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.top: parent.top
                            anchors.topMargin: 4 + index * 24
                            height: 20
                            radius: 4
                            color: modelData.color || "#4A90D9"
                            opacity: 0.8

                            Label {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                text: modelData.title
                                color: "white"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                // 当前时间线
                Item {
                    id: currentTimeLine
                    parent: timelineListView.contentItem
                    x: 0
                    y: {
                        var now = new Date()
                        if (Qt.formatDate(now, "yyyyMMdd") === currentDateStr) {
                            return (now.getHours() * hourHeight) + (now.getMinutes() / 60 * hourHeight)
                        }
                        return -100 // 隐藏
                    }
                    width: timelineListView.width
                    height: 2
                    visible: y >= 0

                    Rectangle {
                        anchors.fill: parent
                        color: "#F44336"
                    }

                    // 时间标签
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 70
                        anchors.verticalCenter: parent.verticalCenter
                        width: 50
                        height: 20
                        radius: 4
                        color: "#F44336"

                        Label {
                            anchors.centerIn: parent
                            text: Qt.formatTime(new Date(), "HH:mm")
                            color: "white"
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
    }

    // 添加任务到时间轴
    function addTaskToTimeline(task) {
        timelineListView.forceLayout()
    }

    // 滚动到当前时间
    function scrollToCurrentTime() {
        var now = new Date()
        var y = (now.getHours() * hourHeight) + (now.getMinutes() / 60 * hourHeight)
        timelineListView.contentY = y - timelineListView.height / 2
    }

    // 初始化
    Component.onCompleted: {
        timelineModel.currentDate = currentDate
        Qt.callLater(scrollToCurrentTime)
    }

    // 定时器更新当前时间线
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: {
            currentTimeLine.y = {
                var now = new Date()
                if (Qt.formatDate(now, "yyyyMMdd") === currentDateStr) {
                    return (now.getHours() * hourHeight) + (now.getMinutes() / 60 * hourHeight)
                }
                return -100
            }
        }
    }
}
