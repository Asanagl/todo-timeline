#ifndef THEMEMANAGER_H
#define THEMEMANAGER_H

#include <QObject>
#include <QSettings>
#include <QStringList>
#include <QVariantMap>

/**
 * @brief 主题管理器：管理自定义配色、深色模式、亚克力效果设置
 *
 * 所有设置通过 QSettings 持久化存储，启动时自动加载。
 * 提供 6 套预设主题方案，支持完整调色板自定义。
 */
class ThemeManager : public QObject
{
    Q_OBJECT

    // 可自定义颜色属性
    Q_PROPERTY(QString primaryColor READ primaryColor WRITE setPrimaryColor NOTIFY primaryColorChanged)
    Q_PROPERTY(QString accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged)
    Q_PROPERTY(QString successColor READ successColor WRITE setSuccessColor NOTIFY successColorChanged)
    Q_PROPERTY(QString warningColor READ warningColor WRITE setWarningColor NOTIFY warningColorChanged)
    Q_PROPERTY(QString dangerColor READ dangerColor WRITE setDangerColor NOTIFY dangerColorChanged)
    Q_PROPERTY(QString backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QString surfaceColor READ surfaceColor WRITE setSurfaceColor NOTIFY surfaceColorChanged)
    Q_PROPERTY(QString textColor READ textColor WRITE setTextColor NOTIFY textColorChanged)
    Q_PROPERTY(QString borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)

    // 主题控制属性
    Q_PROPERTY(bool darkModeEnabled READ darkModeEnabled WRITE setDarkModeEnabled NOTIFY darkModeEnabledChanged)
    Q_PROPERTY(bool acrylicEnabled READ acrylicEnabled WRITE setAcrylicEnabled NOTIFY acrylicEnabledChanged)
    Q_PROPERTY(qreal acrylicOpacity READ acrylicOpacity WRITE setAcrylicOpacity NOTIFY acrylicOpacityChanged)

public:
    explicit ThemeManager(QObject *parent = nullptr);

    // 颜色 getter
    QString primaryColor() const;
    QString accentColor() const;
    QString successColor() const;
    QString warningColor() const;
    QString dangerColor() const;
    QString backgroundColor() const;
    QString surfaceColor() const;
    QString textColor() const;
    QString borderColor() const;

    // 控制属性 getter
    bool darkModeEnabled() const;
    bool acrylicEnabled() const;
    qreal acrylicOpacity() const;

    // 颜色 setter
    void setPrimaryColor(const QString &color);
    void setAccentColor(const QString &color);
    void setSuccessColor(const QString &color);
    void setWarningColor(const QString &color);
    void setDangerColor(const QString &color);
    void setBackgroundColor(const QString &color);
    void setSurfaceColor(const QString &color);
    void setTextColor(const QString &color);
    void setBorderColor(const QString &color);

    // 控制属性 setter
    void setDarkModeEnabled(bool enabled);
    void setAcrylicEnabled(bool enabled);
    void setAcrylicOpacity(qreal opacity);

    // 预设主题
    Q_INVOKABLE QStringList presetNames() const;
    Q_INVOKABLE QVariantMap presetColors(int presetIndex) const;
    Q_INVOKABLE void applyPreset(int presetIndex);
    Q_INVOKABLE void resetToDefault();

signals:
    void primaryColorChanged();
    void accentColorChanged();
    void successColorChanged();
    void warningColorChanged();
    void dangerColorChanged();
    void backgroundColorChanged();
    void surfaceColorChanged();
    void textColorChanged();
    void borderColorChanged();
    void darkModeEnabledChanged();
    void acrylicEnabledChanged();
    void acrylicOpacityChanged();
    void themeChanged();

private:
    void loadSettings();
    void saveSettings();
    void applyPresetColors(const QVariantMap &colors);
    void updateModeAwareColors();
    QString modeAwareColor(const QString &lightColor, const QString &darkColor) const;

    QSettings m_settings;

    // 颜色值（浅色模式基准值）
    QString m_primaryColor;
    QString m_accentColor;
    QString m_successColor;
    QString m_warningColor;
    QString m_dangerColor;
    QString m_backgroundColor;
    QString m_surfaceColor;
    QString m_textColor;
    QString m_borderColor;

    // 控制属性
    bool m_darkModeEnabled;
    bool m_acrylicEnabled;
    qreal m_acrylicOpacity;

    // 默认值
    static const QStringList s_presetNames;
    static const QList<QVariantMap> s_presetColors;
};

#endif // THEMEMANAGER_H
