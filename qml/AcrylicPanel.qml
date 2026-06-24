import QtQuick
import QtQuick.Effects
import "AppConstants.js" as C

/**
 * 可复用亚克力(Acrylic)半透明模糊背景组件
 *
 * 特性：
 * - 支持真实模糊（MultiEffect + ShaderEffectSource）
 * - 支持半透明模拟（性能优先，无模糊）
 * - 优雅降级：acrylicEnabled=false 时回退为不透明
 * - 透明度可调（0.0-1.0）
 */
Rectangle {
    id: acrylicRoot

    // ===== 配置属性 =====
    property real acrylicOpacity: themeManager.acrylicOpacity
    property color tintColor: themeManager.surfaceColor
    property bool blurEnabled: themeManager.acrylicEnabled
    property var blurSource: null
    property int blurRadius: 32

    // ===== 基础半透明背景 =====
    color: {
        var baseAlpha = blurEnabled ? acrylicOpacity : 1.0
        return Qt.rgba(tintColor.r, tintColor.g, tintColor.b, baseAlpha)
    }

    // ===== 真实模糊层（当 blurSource 提供且 blurEnabled 时） =====
    ShaderEffectSource {
        id: blurLayer
        sourceItem: acrylicRoot.blurSource
        visible: acrylicRoot.blurEnabled && acrylicRoot.blurSource !== null
        anchors.fill: parent
        hideSource: false
        textureSize: Qt.size(Math.max(1, Math.floor(width / 2)), Math.max(1, Math.floor(height / 2)))

        layer.enabled: visible
        layer.effect: MultiEffect {
            blur: 0.8
            blurEnabled: true
            blurMax: acrylicRoot.blurRadius
            brightness: 0.05
            saturation: 0.7
            contrast: 0.9
        }
    }

    // ===== 毛玻璃纹理叠加（细微渐变模拟噪点感） =====
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: 0.04
        visible: acrylicRoot.blurEnabled

        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 0.3; color: "transparent" }
            GradientStop { position: 0.7; color: "transparent" }
            GradientStop { position: 1.0; color: "#FFFFFF" }
        }
    }

    // ===== 边框高光（增强层次感） =====
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.15)
        radius: acrylicRoot.radius
        visible: acrylicRoot.blurEnabled
    }
}
