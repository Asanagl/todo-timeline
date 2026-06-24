.pragma library

// 主色调（现代低饱和调色板）
var colorPrimary = "#2563EB"
var colorPrimaryLight = "#3B82F6"
var colorPrimaryDark = "#1D4ED8"
var colorPrimaryBg = "#EFF6FF"

var colorSuccess = "#10B981"
var colorSuccessBg = "#ECFDF5"
var colorWarning = "#F59E0B"
var colorWarningBg = "#FFFBEB"
var colorDanger = "#EF4444"
var colorDangerBg = "#FEF2F2"

var colorPurple = "#8B5CF6"
var colorCyan = "#06B6D4"

// 灰阶与文字
var colorBorderLight = "#E5E7EB"
var colorBorderDark = "#4B5563"
var colorTextSecondary = "#6B7280"
var colorTextMuted = "#9CA3AF"
var colorTextDisabled = "#D1D5DB"
var colorTextDark = "#111827"
var colorTextLight = "#F9FAFB"
// 强调色背景上的文字（统一白色）
var colorTextOnAccent = "#FFFFFF"
// 次要标签文字（替代硬编码 #aaa/#666）
var colorLabelMutedDark = "#AAAAAA"
var colorLabelMutedLight = "#666666"
// 通知背景色（Material Design 深灰）
var colorNotification = "#323232"

// 背景
var colorBgLight = "#F9FAFB"
var colorBgDark = "#111827"
var colorSurfaceLight = "#FFFFFF"
var colorSurfaceDark = "#1F2937"

// 时间轴条纹背景（替代硬编码颜色）
var colorStripeLight = "#f3f4f6"
var colorStripeDark = "#1a2233"

// 优先级标签背景色（半透明，#AARRGGBB 格式）
var priorityLabelBgLow = "#2610B981"
var priorityLabelBgMedium = "#26F59E0B"
var priorityLabelBgHigh = "#26EF4444"

// 完成态背景色
var colorCompletedBgDark = "#1a3a2a"

var taskColors = [
    colorPrimary, colorSuccess, colorWarning,
    colorDanger, colorPurple, colorCyan
]

var priorities = [
    { text: "低", color: colorSuccess, value: 0 },
    { text: "中", color: colorWarning, value: 1 },
    { text: "高", color: colorDanger, value: 2 }
]

// 尺寸
var radiusSmall = 6
var radiusMedium = 10
var radiusLarge = 12
var radiusRound = 18

var spacingSmall = 6
var spacingMedium = 10
var spacingLarge = 14
var spacingXLarge = 18
var spacingXXLarge = 24

var paddingSmall = 10
var paddingMedium = 12
var paddingLarge = 16
var paddingXLarge = 20

var heightSmall = 32
var heightMedium = 40
var heightLarge = 44
var heightXLarge = 52

// 字体
var fontSizeMin = 11
var fontSizeSmall = 12
var fontSizeMedium = 13
var fontSizeLarge = 14
var fontSizeXLarge = 15
var fontSizeTitle = 17
var fontSizeHeader = 19
var fontSizeDisplay = 21

// 徽章/标签标准尺寸
var badgeHeight = 22
var badgeRadius = 11
var badgePaddingH = 10
var badgeFontSize = fontSizeSmall

// 动画
var animDurationFast = 100
var animDurationNormal = 150
var animDurationSlow = 200
var animDurationEnter = 250
var animDurationDialog = 300

// 对话框
var dialogWidthSmall = 320
var dialogWidthMedium = 360
var dialogWidthLarge = 400
var dialogWidthXLarge = 440
var dialogWidthTask = 520
var dialogWidthCategory = 460

// 时间轴任务块
var taskBlockHeight = 24
var taskBlockSpacing = 4
