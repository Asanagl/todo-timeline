#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class Logger : public QObject
{
    Q_OBJECT

public:
    enum LogLevel {
        Debug = 0,
        Info = 1,
        Warning = 2,
        Error = 3
    };

    static Logger* instance();

    void log(LogLevel level, const QString &category, const QString &message);
    void debug(const QString &category, const QString &message);
    void info(const QString &category, const QString &message);
    void warning(const QString &category, const QString &message);
    void error(const QString &category, const QString &message);

    void setLogLevel(LogLevel level);
    void setLogFileEnabled(bool enabled);

private:
    explicit Logger(QObject *parent = nullptr);
    ~Logger() override;

    void writeToFile(LogLevel level, const QString &category, const QString &message);
    QString levelToString(LogLevel level) const;
    QString formatMessage(LogLevel level, const QString &category, const QString &message) const;

    static Logger *m_instance;
    QFile *m_logFile;
    QTextStream *m_logStream;
    LogLevel m_minLevel;
    bool m_fileEnabled;
    static constexpr int MAX_LOG_SIZE = 5 * 1024 * 1024; // 5 MB
};

// Convenience macros
#define LOG_DEBUG(category, message) Logger::instance()->debug(category, message)
#define LOG_INFO(category, message) Logger::instance()->info(category, message)
#define LOG_WARNING(category, message) Logger::instance()->warning(category, message)
#define LOG_ERROR(category, message) Logger::instance()->error(category, message)

#endif // LOGGER_H