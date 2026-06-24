#include "thememanager.h"
#include "logger.h"

#include <QColor>

// 预设主题名称
const QStringList ThemeManager::s_presetNames = {
    QStringLiteral("海洋蓝"),
    QStringLiteral("森林绿"),
    QStringLiteral("日落橙"),
    QStringLiteral("皇家紫"),
    QStringLiteral("极简灰"),
    QStringLiteral("极光")
};

// 预设主题颜色配置（浅色模式）
const QList<QVariantMap> ThemeManager::s_presetColors = {
    // 0: 海洋蓝 (默认)
    {
        {"primaryColor", "#2563EB"}, {"accentColor", "#8B5CF6"},
        {"successColor", "#10B981"}, {"warningColor", "#F59E0B"}, {"dangerColor", "#EF4444"},
        {"backgroundColor", "#F9FAFB"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#111827"}, {"borderColor", "#E5E7EB"}
    },
    // 1: 森林绿
    {
        {"primaryColor", "#10B981"}, {"accentColor", "#06B6D4"},
        {"successColor", "#22C55E"}, {"warningColor", "#EAB308"}, {"dangerColor", "#EF4444"},
        {"backgroundColor", "#F0FDF4"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#14532D"}, {"borderColor", "#BBF7D0"}
    },
    // 2: 日落橙
    {
        {"primaryColor", "#F59E0B"}, {"accentColor", "#EF4444"},
        {"successColor", "#10B981"}, {"warningColor", "#F97316"}, {"dangerColor", "#DC2626"},
        {"backgroundColor", "#FFFBEB"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#78350F"}, {"borderColor", "#FDE68A"}
    },
    // 3: 皇家紫
    {
        {"primaryColor", "#7C3AED"}, {"accentColor", "#EC4899"},
        {"successColor", "#10B981"}, {"warningColor", "#F59E0B"}, {"dangerColor", "#EF4444"},
        {"backgroundColor", "#FAF5FF"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#4C1D95"}, {"borderColor", "#DDD6FE"}
    },
    // 4: 极简灰
    {
        {"primaryColor", "#4B5563"}, {"accentColor", "#6B7280"},
        {"successColor", "#10B981"}, {"warningColor", "#F59E0B"}, {"dangerColor", "#EF4444"},
        {"backgroundColor", "#F9FAFB"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#111827"}, {"borderColor", "#E5E7EB"}
    },
    // 5: 极光
    {
        {"primaryColor", "#06B6D4"}, {"accentColor", "#8B5CF6"},
        {"successColor", "#10B981"}, {"warningColor", "#F59E0B"}, {"dangerColor", "#EF4444"},
        {"backgroundColor", "#ECFEFF"}, {"surfaceColor", "#FFFFFF"},
        {"textColor", "#164E63"}, {"borderColor", "#A5F3FC"}
    }
};

ThemeManager::ThemeManager(QObject *parent)
    : QObject(parent)
    , m_settings(QStringLiteral("TodoApp"), QStringLiteral("Todo Timeline"))
{
    loadSettings();
    LOG_INFO("ThemeManager", QStringLiteral("ThemeManager initialized. Primary: %1, Dark: %2, Acrylic: %3@%4")
        .arg(m_primaryColor).arg(m_darkModeEnabled).arg(m_acrylicEnabled).arg(m_acrylicOpacity));
}

QString ThemeManager::primaryColor() const { return m_primaryColor; }
QString ThemeManager::accentColor() const { return m_accentColor; }
QString ThemeManager::successColor() const { return m_successColor; }
QString ThemeManager::warningColor() const { return m_warningColor; }
QString ThemeManager::dangerColor() const { return m_dangerColor; }

// 模式感知颜色：深色模式下返回深色变体
QString ThemeManager::backgroundColor() const {
    return m_darkModeEnabled ? QStringLiteral("#111827") : m_backgroundColor;
}
QString ThemeManager::surfaceColor() const {
    return m_darkModeEnabled ? QStringLiteral("#1F2937") : m_surfaceColor;
}
QString ThemeManager::textColor() const {
    return m_darkModeEnabled ? QStringLiteral("#F9FAFB") : m_textColor;
}
QString ThemeManager::borderColor() const {
    return m_darkModeEnabled ? QStringLiteral("#4B5563") : m_borderColor;
}

bool ThemeManager::darkModeEnabled() const { return m_darkModeEnabled; }
bool ThemeManager::acrylicEnabled() const { return m_acrylicEnabled; }
qreal ThemeManager::acrylicOpacity() const { return m_acrylicOpacity; }

void ThemeManager::setPrimaryColor(const QString &color) {
    if (m_primaryColor != color) {
        m_primaryColor = color;
        emit primaryColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setAccentColor(const QString &color) {
    if (m_accentColor != color) {
        m_accentColor = color;
        emit accentColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setSuccessColor(const QString &color) {
    if (m_successColor != color) {
        m_successColor = color;
        emit successColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setWarningColor(const QString &color) {
    if (m_warningColor != color) {
        m_warningColor = color;
        emit warningColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setDangerColor(const QString &color) {
    if (m_dangerColor != color) {
        m_dangerColor = color;
        emit dangerColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setBackgroundColor(const QString &color) {
    if (m_backgroundColor != color) {
        m_backgroundColor = color;
        emit backgroundColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setSurfaceColor(const QString &color) {
    if (m_surfaceColor != color) {
        m_surfaceColor = color;
        emit surfaceColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setTextColor(const QString &color) {
    if (m_textColor != color) {
        m_textColor = color;
        emit textColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setBorderColor(const QString &color) {
    if (m_borderColor != color) {
        m_borderColor = color;
        emit borderColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setDarkModeEnabled(bool enabled) {
    if (m_darkModeEnabled != enabled) {
        m_darkModeEnabled = enabled;
        emit darkModeEnabledChanged();
        // 模式感知颜色变更，触发QML绑定更新
        emit backgroundColorChanged();
        emit surfaceColorChanged();
        emit textColorChanged();
        emit borderColorChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setAcrylicEnabled(bool enabled) {
    if (m_acrylicEnabled != enabled) {
        m_acrylicEnabled = enabled;
        emit acrylicEnabledChanged();
        emit themeChanged();
        saveSettings();
    }
}

void ThemeManager::setAcrylicOpacity(qreal opacity) {
    opacity = qBound(0.0, opacity, 1.0);
    if (!qFuzzyCompare(m_acrylicOpacity, opacity)) {
        m_acrylicOpacity = opacity;
        emit acrylicOpacityChanged();
        emit themeChanged();
        saveSettings();
    }
}

QStringList ThemeManager::presetNames() const {
    return s_presetNames;
}

QVariantMap ThemeManager::presetColors(int presetIndex) const {
    if (presetIndex < 0 || presetIndex >= s_presetColors.size()) {
        return QVariantMap();
    }
    return s_presetColors[presetIndex];
}

void ThemeManager::applyPreset(int presetIndex) {
    if (presetIndex < 0 || presetIndex >= s_presetColors.size()) {
        LOG_WARNING("ThemeManager", QStringLiteral("Invalid preset index: %1").arg(presetIndex));
        return;
    }
    applyPresetColors(s_presetColors[presetIndex]);
    LOG_INFO("ThemeManager", QStringLiteral("Applied preset: %1").arg(s_presetNames[presetIndex]));
}

void ThemeManager::resetToDefault() {
    applyPresetColors(s_presetColors[0]);
    m_darkModeEnabled = false;
    m_acrylicEnabled = true;
    m_acrylicOpacity = 0.75;
    emit darkModeEnabledChanged();
    emit acrylicEnabledChanged();
    emit acrylicOpacityChanged();
    emit themeChanged();
    saveSettings();
    LOG_INFO("ThemeManager", "Theme reset to default");
}

void ThemeManager::loadSettings() {
    // 加载颜色，使用预设0作为默认值
    const QVariantMap &defaults = s_presetColors[0];
    m_primaryColor = m_settings.value("primaryColor", defaults["primaryColor"]).toString();
    m_accentColor = m_settings.value("accentColor", defaults["accentColor"]).toString();
    m_successColor = m_settings.value("successColor", defaults["successColor"]).toString();
    m_warningColor = m_settings.value("warningColor", defaults["warningColor"]).toString();
    m_dangerColor = m_settings.value("dangerColor", defaults["dangerColor"]).toString();
    m_backgroundColor = m_settings.value("backgroundColor", defaults["backgroundColor"]).toString();
    m_surfaceColor = m_settings.value("surfaceColor", defaults["surfaceColor"]).toString();
    m_textColor = m_settings.value("textColor", defaults["textColor"]).toString();
    m_borderColor = m_settings.value("borderColor", defaults["borderColor"]).toString();

    m_darkModeEnabled = m_settings.value("darkModeEnabled", false).toBool();
    m_acrylicEnabled = m_settings.value("acrylicEnabled", true).toBool();
    m_acrylicOpacity = m_settings.value("acrylicOpacity", 0.75).toReal();
}

void ThemeManager::saveSettings() {
    m_settings.setValue("primaryColor", m_primaryColor);
    m_settings.setValue("accentColor", m_accentColor);
    m_settings.setValue("successColor", m_successColor);
    m_settings.setValue("warningColor", m_warningColor);
    m_settings.setValue("dangerColor", m_dangerColor);
    m_settings.setValue("backgroundColor", m_backgroundColor);
    m_settings.setValue("surfaceColor", m_surfaceColor);
    m_settings.setValue("textColor", m_textColor);
    m_settings.setValue("borderColor", m_borderColor);
    m_settings.setValue("darkModeEnabled", m_darkModeEnabled);
    m_settings.setValue("acrylicEnabled", m_acrylicEnabled);
    m_settings.setValue("acrylicOpacity", m_acrylicOpacity);
}

void ThemeManager::applyPresetColors(const QVariantMap &colors) {
    if (colors.contains("primaryColor")) setPrimaryColor(colors["primaryColor"].toString());
    if (colors.contains("accentColor")) setAccentColor(colors["accentColor"].toString());
    if (colors.contains("successColor")) setSuccessColor(colors["successColor"].toString());
    if (colors.contains("warningColor")) setWarningColor(colors["warningColor"].toString());
    if (colors.contains("dangerColor")) setDangerColor(colors["dangerColor"].toString());
    if (colors.contains("backgroundColor")) setBackgroundColor(colors["backgroundColor"].toString());
    if (colors.contains("surfaceColor")) setSurfaceColor(colors["surfaceColor"].toString());
    if (colors.contains("textColor")) setTextColor(colors["textColor"].toString());
    if (colors.contains("borderColor")) setBorderColor(colors["borderColor"].toString());
}

void ThemeManager::updateModeAwareColors() {
    // 模式感知颜色已在 getter 中处理，这里仅触发信号
    emit backgroundColorChanged();
    emit surfaceColorChanged();
    emit textColorChanged();
    emit borderColorChanged();
}

QString ThemeManager::modeAwareColor(const QString &lightColor, const QString &darkColor) const {
    return m_darkModeEnabled ? darkColor : lightColor;
}
