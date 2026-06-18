#include "logger.h"

Logger *Logger::m_instance = nullptr;

Logger::Logger(QObject *parent)
    : QObject(parent)
    , m_logFile(nullptr)
    , m_logStream(nullptr)
    , m_minLevel(Info)
    , m_fileEnabled(true)
{
    QString logPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(logPath);
    if (!dir.exists()) {
        dir.mkpath(QStringLiteral("."));
    }

    m_logFile = new QFile(logPath + QStringLiteral("/todo.log"), this);
    if (m_fileEnabled && m_logFile->open(QIODevice::WriteOnly | QIODevice::Append)) {
        m_logStream = new QTextStream(m_logFile);
        m_logStream->setEncoding(QStringConverter::Utf8);
    }
}

Logger::~Logger()
{
    if (m_logStream) {
        m_logStream->flush();
        delete m_logStream;
        m_logStream = nullptr;
    }
    if (m_logFile) {
        m_logFile->close();
    }
}

Logger* Logger::instance()
{
    if (!m_instance) {
        m_instance = new Logger();
    }
    return m_instance;
}

void Logger::log(LogLevel level, const QString &category, const QString &message)
{
    if (level < m_minLevel) return;

    QString formatted = formatMessage(level, category, message);

    // Output to console
    switch (level) {
    case Debug:
        qDebug().noquote() << formatted;
        break;
    case Info:
        qInfo().noquote() << formatted;
        break;
    case Warning:
        qWarning().noquote() << formatted;
        break;
    case Error:
        qCritical().noquote() << formatted;
        break;
    }

    // Write to file
    if (m_fileEnabled && m_logStream) {
        writeToFile(level, category, message);
    }
}

void Logger::debug(const QString &category, const QString &message)
{
    log(Debug, category, message);
}

void Logger::info(const QString &category, const QString &message)
{
    log(Info, category, message);
}

void Logger::warning(const QString &category, const QString &message)
{
    log(Warning, category, message);
}

void Logger::error(const QString &category, const QString &message)
{
    log(Error, category, message);
}

void Logger::setLogLevel(LogLevel level)
{
    m_minLevel = level;
}

void Logger::setLogFileEnabled(bool enabled)
{
    m_fileEnabled = enabled;
    if (enabled && m_logFile && !m_logFile->isOpen()) {
        m_logFile->open(QIODevice::WriteOnly | QIODevice::Append);
        if (m_logStream == nullptr && m_logFile->isOpen()) {
            m_logStream = new QTextStream(m_logFile);
            m_logStream->setEncoding(QStringConverter::Utf8);
        }
    } else if (!enabled && m_logFile && m_logFile->isOpen()) {
        m_logFile->close();
    }
}

void Logger::writeToFile(LogLevel level, const QString &category, const QString &message)
{
    if (!m_logStream) return;

    // Rotate log if too large
    if (m_logFile && m_logFile->size() > MAX_LOG_SIZE) {
        m_logStream->flush();
        m_logFile->close();
        
        QString logPath = m_logFile->fileName();
        QString oldPath = logPath + QStringLiteral(".old");
        QFile::remove(oldPath);
        QFile::rename(logPath, oldPath);
        
        m_logFile->open(QIODevice::WriteOnly | QIODevice::Append);
        *m_logStream << QStringLiteral("=== Log rotated at ") 
                     << QDateTime::currentDateTime().toString(Qt::ISODate) 
                     << QStringLiteral(" ===\n");
    }

    *m_logStream << formatMessage(level, category, message) << QStringLiteral("\n");
    m_logStream->flush();
}

QString Logger::levelToString(LogLevel level) const
{
    switch (level) {
    case Debug: return QStringLiteral("DEBUG");
    case Info: return QStringLiteral("INFO");
    case Warning: return QStringLiteral("WARN");
    case Error: return QStringLiteral("ERROR");
    default: return QStringLiteral("UNKNOWN");
    }
}

QString Logger::formatMessage(LogLevel level, const QString &category, const QString &message) const
{
    return QStringLiteral("[%1] [%2] %3: %4")
        .arg(QDateTime::currentDateTime().toString(QStringLiteral("yyyy-MM-dd HH:mm:ss")))
        .arg(levelToString(level))
        .arg(category)
        .arg(message);
}