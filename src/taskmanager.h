#ifndef TASKMANAGER_H
#define TASKMANAGER_H

#include <QObject>
#include <QQmlListProperty>
#include <QDateTime>
#include <QUuid>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QUrl>
#include <QTimer>
#include <QHash>
#include <QRegularExpression>

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY idChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QDateTime startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(QDateTime endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)
    Q_PROPERTY(bool completed READ completed WRITE setCompleted NOTIFY completedChanged)
    Q_PROPERTY(int priority READ priority WRITE setPriority NOTIFY priorityChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(bool scheduled READ scheduled WRITE setScheduled NOTIFY scheduledChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(bool hasReminder READ hasReminder WRITE setHasReminder NOTIFY hasReminderChanged)
    Q_PROPERTY(QDateTime reminderTime READ reminderTime WRITE setReminderTime NOTIFY reminderTimeChanged)

public:
    explicit Task(QObject *parent = nullptr);
    Task(const QString &title, const QString &description, QObject *parent = nullptr);

    QString id() const;
    void setId(const QString &id);

    QString title() const;
    void setTitle(const QString &title);

    QString description() const;
    void setDescription(const QString &description);

    QDateTime startTime() const;
    void setStartTime(const QDateTime &startTime);

    QDateTime endTime() const;
    void setEndTime(const QDateTime &endTime);

    bool completed() const;
    void setCompleted(bool completed);

    int priority() const;
    void setPriority(int priority);

    QString color() const;
    void setColor(const QString &color);

    bool scheduled() const;
    void setScheduled(bool scheduled);

    QString category() const;
    void setCategory(const QString &category);

    bool hasReminder() const;
    void setHasReminder(bool hasReminder);

    QDateTime reminderTime() const;
    void setReminderTime(const QDateTime &reminderTime);

    QJsonObject toJson() const;
    static Task* fromJson(const QJsonObject &json, QObject *parent = nullptr);

    // Validation helpers
    static bool isValidColor(const QString &color);
    static QString sanitizeTitle(const QString &title);
    static QString sanitizeDescription(const QString &description);

signals:
    void idChanged();
    void titleChanged();
    void descriptionChanged();
    void startTimeChanged();
    void endTimeChanged();
    void completedChanged();
    void priorityChanged();
    void colorChanged();
    void scheduledChanged();
    void categoryChanged();
    void hasReminderChanged();
    void reminderTimeChanged();

private:
    QString m_id;
    QString m_title;
    QString m_description;
    QDateTime m_startTime;
    QDateTime m_endTime;
    bool m_completed;
    int m_priority;
    QString m_color;
    bool m_scheduled;
    QString m_category;
    bool m_hasReminder;
    QDateTime m_reminderTime;

    static constexpr int MAX_TITLE_LENGTH = 200;
    static constexpr int MAX_DESCRIPTION_LENGTH = 2000;
};

// Category class for folder functionality
class Category : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id CONSTANT)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int taskCount READ taskCount NOTIFY taskCountChanged)

public:
    explicit Category(const QString &name, const QString &color, QObject *parent = nullptr);

    QString id() const;
    QString name() const;
    void setName(const QString &name);
    QString color() const;
    void setColor(const QString &color);
    int taskCount() const;
    void setTaskCount(int count);

    QJsonObject toJson() const;
    static Category* fromJson(const QJsonObject &json, QObject *parent = nullptr);

signals:
    void nameChanged();
    void colorChanged();
    void taskCountChanged();

private:
    QString m_id;
    QString m_name;
    QString m_color;
    int m_taskCount;
};

class TaskManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Task> tasks READ tasks NOTIFY tasksChanged)
    Q_PROPERTY(QQmlListProperty<Task> scheduledTasks READ scheduledTasks NOTIFY scheduledTasksChanged)
    Q_PROPERTY(QQmlListProperty<Category> categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)
    Q_PROPERTY(QString currentCategory READ currentCategory WRITE setCurrentCategory NOTIFY currentCategoryChanged)
    Q_PROPERTY(int totalTaskCount READ totalTaskCount NOTIFY tasksChanged)
    Q_PROPERTY(int completedTaskCount READ completedTaskCount NOTIFY tasksChanged)
    // 性能优化：C++ 端过滤后的任务列表，避免 QML delegate.visible 反模式
    Q_PROPERTY(QQmlListProperty<Task> filteredTasks READ filteredTasks NOTIFY filteredTasksChanged)
    // 时间轴强制刷新版本号，每次 scheduledTasks 变化时递增
    Q_PROPERTY(int scheduledTasksVersion READ scheduledTasksVersion NOTIFY scheduledTasksChanged)

public:
    explicit TaskManager(QObject *parent = nullptr);
    ~TaskManager() override;

    QQmlListProperty<Task> tasks();
    QQmlListProperty<Task> scheduledTasks();
    QQmlListProperty<Category> categories();
    // 性能优化：C++ 端过滤
    QQmlListProperty<Task> filteredTasks();

    QString filterText() const;
    void setFilterText(const QString &text);

    QString currentCategory() const;
    void setCurrentCategory(const QString &categoryId);

    int totalTaskCount() const;
    int completedTaskCount() const;
    int scheduledTasksVersion() const { return m_scheduledTasksVersion; }

    // Task operations
    Q_INVOKABLE QString addTask(const QString &title, const QString &description);
    Q_INVOKABLE QString addTaskWithCategory(const QString &title, const QString &description, const QString &categoryId);
    Q_INVOKABLE void removeTask(const QString &taskId);
    Q_INVOKABLE void updateTaskFull(const QString &taskId, const QString &title, const QString &description,
                                     int priority, const QString &color, const QString &categoryId);
    // 功能补全：更新任务时间安排（供 TaskEditor 使用）
    Q_INVOKABLE void updateTaskSchedule(const QString &taskId, const QDateTime &startTime, const QDateTime &endTime, bool scheduled);
    // 功能补全：更新任务提醒设置（供 TaskEditor 使用）
    Q_INVOKABLE void updateTaskReminder(const QString &taskId, bool hasReminder, const QDateTime &reminderTime);
    Q_INVOKABLE void toggleTaskCompletion(const QString &taskId);
    Q_INVOKABLE void scheduleTask(const QString &taskId, const QDateTime &startTime, const QDateTime &endTime);
    Q_INVOKABLE void unscheduleTask(const QString &taskId);
    Q_INVOKABLE void moveTask(const QString &taskId, const QDateTime &newStartTime);
    Q_INVOKABLE void setTaskReminder(const QString &taskId, const QDateTime &reminderTime);
    Q_INVOKABLE void clearTaskReminder(const QString &taskId);

    // Category operations
    Q_INVOKABLE void addCategory(const QString &name, const QString &color);
    Q_INVOKABLE void removeCategory(const QString &categoryId);
    Q_INVOKABLE void updateCategory(const QString &categoryId, const QString &name, const QString &color);

    // Query operations
    Q_INVOKABLE Task* findTask(const QString &taskId) const;
    Q_INVOKABLE Category* findCategory(const QString &categoryId) const;
    Q_INVOKABLE int taskCountFiltered();
    Q_INVOKABLE QList<QObject*> tasksForCategory(const QString &categoryId) const;
    // 性能优化：查询某天某小时的任务，避免 QML 端 Repeater 遍历
    Q_INVOKABLE QList<Task*> tasksForHour(const QDate &date, int hour) const;

    // Persistence
    Q_INVOKABLE void saveTasks();
    Q_INVOKABLE void loadTasks();
    Q_INVOKABLE bool exportTasks(const QUrl &fileUrl);
    Q_INVOKABLE bool importTasks(const QUrl &fileUrl);

signals:
    void tasksChanged();
    void scheduledTasksChanged();
    void categoriesChanged();
    void filterTextChanged();
    void currentCategoryChanged();
    void filteredTasksChanged();
    void taskAdded(Task *task);
    void taskRemoved(const QString &taskId);
    void taskScheduled(Task *task);
    void taskUnscheduled(const QString &taskId);
    void taskReminderTriggered(Task *task);
    void exportFinished(bool success, const QString &message);
    void importFinished(bool success, const QString &message);

private:
    void scheduleSave();
    void rebuildScheduledList();
    void updateCategoryTaskCounts();
    bool validateTaskJson(const QJsonObject &json) const;
    void checkReminders();
    void saveCategories();
    void loadCategories();
    void rebuildFilteredTasks();  // 性能优化：重建过滤后列表
    void invalidateFilter();      // 性能优化：使过滤缓存失效
    void rebuildTasksByHourCache() const;  // 性能优化：预构建按小时分组的缓存
    void updateCategoryTaskCount(const QString &categoryId, int delta);  // 性能优化：增量更新分类计数
    void updateReminderFlag();  // 性能优化：更新全局提醒标记

    QList<Task*> m_tasks;
    QList<Task*> m_scheduledTasks;
    QList<Task*> m_filteredTasks;  // 性能优化：缓存过滤结果
    QList<Category*> m_categories;
    QHash<QString, Task*> m_taskHash;  // Fast lookup by ID
    QHash<QString, Category*> m_categoryHash;
    QString m_savePath;
    QString m_filterText;
    QString m_currentCategory;
    QTimer *m_saveTimer;
    QTimer *m_reminderTimer;
    bool m_loading;
    mutable int m_cachedFilteredCount;
    mutable bool m_filterCacheValid;
    mutable int m_cachedCompletedCount;  // 性能优化：缓存已完成数量
    mutable bool m_completedCountDirty;  // 性能优化：脏标记
    int m_scheduledTasksVersion = 0;  // 时间轴强制刷新版本号
    // 性能优化：按日期+小时预分组缓存，避免 24 次遍历
    mutable QHash<QDate, QVector<QList<Task*>>> m_tasksByHourCache;
    mutable bool m_tasksByHourCacheValid = false;
    bool m_hasAnyReminders = false;  // 性能优化：快速跳过提醒检查

    static constexpr int SAVE_DEBOUNCE_MS = 500;
    static constexpr int REMINDER_CHECK_MS = 60000; // Check every minute
    static constexpr int MAX_TASKS = 10000;
    static constexpr int MAX_IMPORT_SIZE = 10 * 1024 * 1024; // 10 MB
    static constexpr int MAX_CATEGORIES = 100;
};

#endif // TASKMANAGER_H
