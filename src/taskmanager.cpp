#include "taskmanager.h"
#include "logger.h"
#include <QDebug>

// ========== Task Implementation ==========

Task::Task(QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_completed(false)
    , m_priority(0)
    , m_color(QStringLiteral("#4A90D9"))
    , m_scheduled(false)
    , m_category(QStringLiteral(""))
    , m_hasReminder(false)
{
}

Task::Task(const QString &title, const QString &description, QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_title(sanitizeTitle(title))
    , m_description(sanitizeDescription(description))
    , m_completed(false)
    , m_priority(0)
    , m_color(QStringLiteral("#4A90D9"))
    , m_scheduled(false)
    , m_category(QStringLiteral(""))
    , m_hasReminder(false)
{
}

QString Task::id() const { return m_id; }
void Task::setId(const QString &id) {
    if (m_id != id) {
        m_id = id;
        emit idChanged();
    }
}

QString Task::title() const { return m_title; }
void Task::setTitle(const QString &title) {
    QString sanitized = sanitizeTitle(title);
    if (m_title != sanitized) {
        m_title = sanitized;
        emit titleChanged();
    }
}

QString Task::description() const { return m_description; }
void Task::setDescription(const QString &description) {
    QString sanitized = sanitizeDescription(description);
    if (m_description != sanitized) {
        m_description = sanitized;
        emit descriptionChanged();
    }
}

QDateTime Task::startTime() const { return m_startTime; }
void Task::setStartTime(const QDateTime &startTime) {
    if (m_startTime != startTime) {
        m_startTime = startTime;
        emit startTimeChanged();
    }
}

QDateTime Task::endTime() const { return m_endTime; }
void Task::setEndTime(const QDateTime &endTime) {
    if (m_endTime != endTime) {
        m_endTime = endTime;
        emit endTimeChanged();
    }
}

bool Task::completed() const { return m_completed; }
void Task::setCompleted(bool completed) {
    if (m_completed != completed) {
        m_completed = completed;
        emit completedChanged();
    }
}

int Task::priority() const { return m_priority; }
void Task::setPriority(int priority) {
    priority = qBound(0, priority, 2);
    if (m_priority != priority) {
        m_priority = priority;
        emit priorityChanged();
    }
}

QString Task::color() const { return m_color; }
void Task::setColor(const QString &color) {
    QString validColor = isValidColor(color) ? color : QStringLiteral("#4A90D9");
    if (m_color != validColor) {
        m_color = validColor;
        emit colorChanged();
    }
}

bool Task::scheduled() const { return m_scheduled; }
void Task::setScheduled(bool scheduled) {
    if (m_scheduled != scheduled) {
        m_scheduled = scheduled;
        emit scheduledChanged();
    }
}

QString Task::category() const { return m_category; }
void Task::setCategory(const QString &category) {
    if (m_category != category) {
        m_category = category;
        emit categoryChanged();
    }
}

bool Task::hasReminder() const { return m_hasReminder; }
void Task::setHasReminder(bool hasReminder) {
    if (m_hasReminder != hasReminder) {
        m_hasReminder = hasReminder;
        emit hasReminderChanged();
    }
}

QDateTime Task::reminderTime() const { return m_reminderTime; }
void Task::setReminderTime(const QDateTime &reminderTime) {
    if (m_reminderTime != reminderTime) {
        m_reminderTime = reminderTime;
        emit reminderTimeChanged();
    }
}

bool Task::isValidColor(const QString &color) {
    // Validate hex color format: #RRGGBB or #RGB
    static QRegularExpression hexColorRegex(QStringLiteral("^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})$"));
    return hexColorRegex.match(color).hasMatch();
}

QString Task::sanitizeTitle(const QString &title) {
    QString trimmed = title.trimmed();
    if (trimmed.length() > MAX_TITLE_LENGTH) {
        trimmed = trimmed.left(MAX_TITLE_LENGTH);
        LOG_WARNING("Task", QStringLiteral("Title truncated to %1 characters").arg(MAX_TITLE_LENGTH));
    }
    return trimmed;
}

QString Task::sanitizeDescription(const QString &description) {
    QString trimmed = description.trimmed();
    if (trimmed.length() > MAX_DESCRIPTION_LENGTH) {
        trimmed = trimmed.left(MAX_DESCRIPTION_LENGTH);
        LOG_WARNING("Task", QStringLiteral("Description truncated to %1 characters").arg(MAX_DESCRIPTION_LENGTH));
    }
    return trimmed;
}

QJsonObject Task::toJson() const {
    QJsonObject json;
    json[QStringLiteral("id")] = m_id;
    json[QStringLiteral("title")] = m_title;
    json[QStringLiteral("description")] = m_description;
    json[QStringLiteral("startTime")] = m_startTime.toString(Qt::ISODate);
    json[QStringLiteral("endTime")] = m_endTime.toString(Qt::ISODate);
    json[QStringLiteral("completed")] = m_completed;
    json[QStringLiteral("priority")] = m_priority;
    json[QStringLiteral("color")] = m_color;
    json[QStringLiteral("scheduled")] = m_scheduled;
    json[QStringLiteral("category")] = m_category;
    json[QStringLiteral("hasReminder")] = m_hasReminder;
    json[QStringLiteral("reminderTime")] = m_reminderTime.toString(Qt::ISODate);
    return json;
}

Task* Task::fromJson(const QJsonObject &json, QObject *parent) {
    Task *task = new Task(parent);
    task->m_id = json.value(QStringLiteral("id")).toString(task->m_id);
    task->m_title = sanitizeTitle(json.value(QStringLiteral("title")).toString());
    task->m_description = sanitizeDescription(json.value(QStringLiteral("description")).toString());
    task->m_startTime = QDateTime::fromString(json.value(QStringLiteral("startTime")).toString(), Qt::ISODate);
    task->m_endTime = QDateTime::fromString(json.value(QStringLiteral("endTime")).toString(), Qt::ISODate);
    task->m_completed = json.value(QStringLiteral("completed")).toBool(false);
    task->m_priority = qBound(0, json.value(QStringLiteral("priority")).toInt(0), 2);
    task->m_color = isValidColor(json.value(QStringLiteral("color")).toString()) 
        ? json.value(QStringLiteral("color")).toString() 
        : QStringLiteral("#4A90D9");
    task->m_scheduled = json.value(QStringLiteral("scheduled")).toBool(false);
    task->m_category = json.value(QStringLiteral("category")).toString(QStringLiteral(""));
    task->m_hasReminder = json.value(QStringLiteral("hasReminder")).toBool(false);
    task->m_reminderTime = QDateTime::fromString(json.value(QStringLiteral("reminderTime")).toString(), Qt::ISODate);
    return task;
}

// ========== Category Implementation ==========

Category::Category(const QString &name, const QString &color, QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_name(name.trimmed())
    , m_color(Task::isValidColor(color) ? color : QStringLiteral("#4A90D9"))
    , m_taskCount(0)
{
}

QString Category::id() const { return m_id; }

QString Category::name() const { return m_name; }
void Category::setName(const QString &name) {
    QString trimmed = name.trimmed();
    if (trimmed.length() > 50) {
        trimmed = trimmed.left(50);
    }
    if (m_name != trimmed) {
        m_name = trimmed;
        emit nameChanged();
    }
}

QString Category::color() const { return m_color; }
void Category::setColor(const QString &color) {
    QString validColor = Task::isValidColor(color) ? color : QStringLiteral("#4A90D9");
    if (m_color != validColor) {
        m_color = validColor;
        emit colorChanged();
    }
}

int Category::taskCount() const { return m_taskCount; }
void Category::setTaskCount(int count) {
    if (m_taskCount != count) {
        m_taskCount = count;
        emit taskCountChanged();
    }
}

QJsonObject Category::toJson() const {
    QJsonObject json;
    json[QStringLiteral("id")] = m_id;
    json[QStringLiteral("name")] = m_name;
    json[QStringLiteral("color")] = m_color;
    return json;
}

Category* Category::fromJson(const QJsonObject &json, QObject *parent) {
    QString id = json.value(QStringLiteral("id")).toString();
    QString name = json.value(QStringLiteral("name")).toString();
    QString color = json.value(QStringLiteral("color")).toString(QStringLiteral("#4A90D9"));
    
    Category *category = new Category(name, color, parent);
    if (!id.isEmpty()) {
        category->m_id = id;
    }
    return category;
}

// ========== TaskManager Implementation ==========

TaskManager::TaskManager(QObject *parent)
    : QObject(parent)
    , m_loading(false)
    , m_cachedFilteredCount(0)
    , m_filterCacheValid(false)
{
    m_savePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(m_savePath);
    if (!dir.exists()) {
        dir.mkpath(QStringLiteral("."));
    }

    // Debounced save timer
    m_saveTimer = new QTimer(this);
    m_saveTimer->setSingleShot(true);
    m_saveTimer->setInterval(SAVE_DEBOUNCE_MS);
    connect(m_saveTimer, &QTimer::timeout, this, &TaskManager::saveTasks);

    // Reminder check timer
    m_reminderTimer = new QTimer(this);
    m_reminderTimer->setInterval(REMINDER_CHECK_MS);
    connect(m_reminderTimer, &QTimer::timeout, this, &TaskManager::checkReminders);
    m_reminderTimer->start();

    loadCategories();
    loadTasks();

    LOG_INFO("TaskManager", QStringLiteral("Initialized with %1 tasks and %2 categories")
        .arg(m_tasks.size()).arg(m_categories.size()));
}

TaskManager::~TaskManager() {
    saveTasks();
    saveCategories();
    LOG_INFO("TaskManager", QStringLiteral("Shutdown complete"));
}

QQmlListProperty<Task> TaskManager::tasks() {
    return QQmlListProperty<Task>(this,
        &TaskManager::appendTask,
        &TaskManager::taskCount,
        &TaskManager::task,
        &TaskManager::clearTasks);
}

QQmlListProperty<Task> TaskManager::scheduledTasks() {
    return QQmlListProperty<Task>(this,
        nullptr,
        [](QQmlListProperty<Task> *list) -> qsizetype {
            auto *manager = static_cast<TaskManager*>(list->object);
            return manager->m_scheduledTasks.count();
        },
        [](QQmlListProperty<Task> *list, qsizetype index) -> Task* {
            auto *manager = static_cast<TaskManager*>(list->object);
            return manager->m_scheduledTasks.value(index, nullptr);
        },
        nullptr);
}

QQmlListProperty<Category> TaskManager::categories() {
    return QQmlListProperty<Category>(this,
        &TaskManager::appendCategory,
        &TaskManager::categoryCount,
        &TaskManager::category,
        &TaskManager::clearCategories);
}

QString TaskManager::filterText() const { return m_filterText; }

void TaskManager::setFilterText(const QString &text) {
    if (m_filterText != text) {
        m_filterText = text;
        m_filterCacheValid = false;
        emit filterTextChanged();
        emit tasksChanged();
    }
}

QString TaskManager::currentCategory() const { return m_currentCategory; }
void TaskManager::setCurrentCategory(const QString &categoryId) {
    if (m_currentCategory != categoryId) {
        m_currentCategory = categoryId;
        m_filterCacheValid = false;
        emit currentCategoryChanged();
        emit tasksChanged();
    }
}

int TaskManager::totalTaskCount() const { return m_tasks.size(); }

int TaskManager::completedTaskCount() const {
    int count = 0;
    for (const Task *task : m_tasks) {
        if (task->completed()) count++;
    }
    return count;
}

bool TaskManager::validateTaskJson(const QJsonObject &json) const {
    return json.contains(QStringLiteral("title")) && json.value(QStringLiteral("title")).isString();
}

void TaskManager::scheduleSave() {
    if (!m_loading) {
        m_saveTimer->start();
    }
}

void TaskManager::rebuildScheduledList() {
    m_scheduledTasks.clear();
    m_scheduledTasks.reserve(m_tasks.size());
    for (Task *task : m_tasks) {
        if (task->scheduled()) {
            m_scheduledTasks.append(task);
        }
    }
}

void TaskManager::updateCategoryTaskCounts() {
    QHash<QString, int> counts;
    for (const Task *task : m_tasks) {
        QString cat = task->category();
        if (!cat.isEmpty()) {
            counts[cat]++;
        }
    }
    for (Category *category : m_categories) {
        category->setTaskCount(counts.value(category->id(), 0));
    }
}

void TaskManager::checkReminders() {
    QDateTime now = QDateTime::currentDateTime();
    for (Task *task : m_tasks) {
        if (task->hasReminder() && task->reminderTime().isValid()) {
            // Trigger reminder if within 1 minute of reminder time
            qint64 diff = qAbs(task->reminderTime().secsTo(now));
            if (diff <= 60 && !task->completed()) {
                emit taskReminderTriggered(task);
                LOG_INFO("Reminder", QStringLiteral("Reminder triggered for task: %1").arg(task->title()));
                // Clear reminder after triggering to prevent repeated alerts
                task->setHasReminder(false);
            }
        }
    }
}

void TaskManager::saveCategories() {
    QJsonArray categoriesArray;
    // Note: QJsonArray does not support reserve in Qt6
    for (const Category *category : m_categories) {
        categoriesArray.append(category->toJson());
    }

    QJsonDocument doc(categoriesArray);
    const QString filePath = m_savePath + QStringLiteral("/categories.json");
    const QString tmpPath = filePath + QStringLiteral(".tmp");

    QFile tmpFile(tmpPath);
    if (tmpFile.open(QIODevice::WriteOnly)) {
        tmpFile.write(doc.toJson(QJsonDocument::Compact));
        tmpFile.close();
        QFile::remove(filePath);
        if (!QFile::rename(tmpPath, filePath)) {
            LOG_ERROR("TaskManager", QStringLiteral("Failed to save categories: rename failed"));
            QFile::remove(tmpPath);
        }
    }
}

void TaskManager::loadCategories() {
    QFile file(m_savePath + QStringLiteral("/categories.json"));
    if (file.open(QIODevice::ReadOnly)) {
        const QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (doc.isArray()) {
            const QJsonArray categoriesArray = doc.array();
            for (const QJsonValue &value : categoriesArray) {
                if (value.isObject()) {
                    Category *category = Category::fromJson(value.toObject(), this);
                    m_categories.append(category);
                    m_categoryHash[category->id()] = category;
                }
            }
        }
    }
}

void TaskManager::addTask(const QString &title, const QString &description) {
    addTaskWithCategory(title, description, m_currentCategory);
}

void TaskManager::addTaskWithCategory(const QString &title, const QString &description, const QString &categoryId) {
    if (m_tasks.size() >= MAX_TASKS) {
        LOG_WARNING("TaskManager", QStringLiteral("Maximum task count reached: %1").arg(MAX_TASKS));
        return;
    }
    const QString trimmedTitle = title.trimmed();
    if (trimmedTitle.isEmpty()) return;

    Task *task = new Task(trimmedTitle, description, this);
    if (!categoryId.isEmpty() && m_categoryHash.contains(categoryId)) {
        task->setCategory(categoryId);
    }
    
    m_tasks.append(task);
    m_taskHash[task->id()] = task;
    m_filterCacheValid = false;
    
    emit tasksChanged();
    emit taskAdded(task);
    updateCategoryTaskCounts();
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Added task: %1").arg(task->title()));
}

void TaskManager::removeTask(const QString &taskId) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    m_taskHash.remove(taskId);
    m_tasks.removeOne(task);
    emit taskRemoved(taskId);

    m_scheduledTasks.removeOne(task);
    emit scheduledTasksChanged();

    m_filterCacheValid = false;
    delete task;
    emit tasksChanged();
    updateCategoryTaskCounts();
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Removed task: %1").arg(taskId));
}

void TaskManager::updateTaskFull(const QString &taskId, const QString &title, const QString &description,
                                  int priority, const QString &color, const QString &categoryId) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    const QString trimmedTitle = title.trimmed();
    if (trimmedTitle.isEmpty()) return;

    QString oldCategory = task->category();
    
    task->setTitle(trimmedTitle);
    task->setDescription(description.trimmed());
    task->setPriority(qBound(0, priority, 2));
    task->setColor(color);
    
    if (!categoryId.isEmpty() && m_categoryHash.contains(categoryId)) {
        task->setCategory(categoryId);
    } else if (categoryId.isEmpty()) {
        task->setCategory(QStringLiteral(""));
    }
    
    m_filterCacheValid = false;
    emit tasksChanged();
    
    if (oldCategory != task->category()) {
        updateCategoryTaskCounts();
    }
    scheduleSave();
}

Task* TaskManager::findTask(const QString &taskId) const {
    return m_taskHash.value(taskId, nullptr);
}

Category* TaskManager::findCategory(const QString &categoryId) const {
    return m_categoryHash.value(categoryId, nullptr);
}

int TaskManager::taskCountFiltered() const {
    if (m_filterCacheValid) return m_cachedFilteredCount;
    
    int count = 0;
    const QString lower = m_filterText.toLower();
    for (const Task *task : m_tasks) {
        // Category filter
        if (!m_currentCategory.isEmpty() && task->category() != m_currentCategory) {
            continue;
        }
        // Text filter
        if (m_filterText.isEmpty() ||
            task->title().contains(lower, Qt::CaseInsensitive) ||
            task->description().contains(lower, Qt::CaseInsensitive)) {
            count++;
        }
    }
    
    // Cache result
    m_cachedFilteredCount = count;
    m_filterCacheValid = true;
    return count;
}

QList<QObject*> TaskManager::tasksForCategory(const QString &categoryId) const {
    QList<QObject*> result;
    for (Task *task : m_tasks) {
        if (task->category() == categoryId) {
            result.append(task);
        }
    }
    return result;
}

void TaskManager::toggleTaskCompletion(const QString &taskId) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    task->setCompleted(!task->completed());
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Task %1 completion toggled to %2")
        .arg(task->title()).arg(task->completed()));
}

void TaskManager::scheduleTask(const QString &taskId, const QDateTime &startTime, const QDateTime &endTime) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    task->setStartTime(startTime);
    task->setEndTime(endTime);
    task->setScheduled(true);

    if (!m_scheduledTasks.contains(task)) {
        m_scheduledTasks.append(task);
        emit scheduledTasksChanged();
    }

    emit taskScheduled(task);
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Scheduled task: %1 from %2 to %3")
        .arg(task->title())
        .arg(startTime.toString())
        .arg(endTime.toString()));
}

void TaskManager::unscheduleTask(const QString &taskId) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    task->setScheduled(false);
    task->setStartTime(QDateTime());
    task->setEndTime(QDateTime());

    if (m_scheduledTasks.removeOne(task)) {
        emit scheduledTasksChanged();
    }

    emit taskUnscheduled(taskId);
    scheduleSave();
}

void TaskManager::moveTask(const QString &taskId, const QDateTime &newStartTime) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task || !task->scheduled()) return;

    const qint64 duration = task->startTime().secsTo(task->endTime());
    task->setStartTime(newStartTime);
    task->setEndTime(newStartTime.addSecs(duration));
    scheduleSave();
}

void TaskManager::setTaskReminder(const QString &taskId, const QDateTime &reminderTime) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    task->setReminderTime(reminderTime);
    task->setHasReminder(true);
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Set reminder for task %1 at %2")
        .arg(task->title()).arg(reminderTime.toString()));
}

void TaskManager::clearTaskReminder(const QString &taskId) {
    Task *task = m_taskHash.value(taskId, nullptr);
    if (!task) return;

    task->setHasReminder(false);
    task->setReminderTime(QDateTime());
    scheduleSave();
}

void TaskManager::addCategory(const QString &name, const QString &color) {
    if (m_categories.size() >= MAX_CATEGORIES) {
        LOG_WARNING("TaskManager", QStringLiteral("Maximum category count reached"));
        return;
    }
    
    QString trimmedName = name.trimmed();
    if (trimmedName.isEmpty()) return;

    Category *category = new Category(trimmedName, color, this);
    m_categories.append(category);
    m_categoryHash[category->id()] = category;
    
    emit categoriesChanged();
    saveCategories();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Added category: %1").arg(category->name()));
}

void TaskManager::removeCategory(const QString &categoryId) {
    Category *category = m_categoryHash.value(categoryId, nullptr);
    if (!category) return;

    // Remove category from all tasks
    for (Task *task : m_tasks) {
        if (task->category() == categoryId) {
            task->setCategory(QStringLiteral(""));
        }
    }

    m_categoryHash.remove(categoryId);
    m_categories.removeOne(category);
    delete category;

    if (m_currentCategory == categoryId) {
        m_currentCategory = QStringLiteral("");
        emit currentCategoryChanged();
    }

    emit categoriesChanged();
    emit tasksChanged();
    saveCategories();
    scheduleSave();
    
    LOG_DEBUG("TaskManager", QStringLiteral("Removed category: %1").arg(categoryId));
}

void TaskManager::updateCategory(const QString &categoryId, const QString &name, const QString &color) {
    Category *category = m_categoryHash.value(categoryId, nullptr);
    if (!category) return;

    category->setName(name);
    category->setColor(color);
    emit categoriesChanged();
    saveCategories();
}

void TaskManager::saveTasks() {
    QJsonArray tasksArray;
    // Note: QJsonArray does not support reserve in Qt6
    for (const Task *task : m_tasks) {
        tasksArray.append(task->toJson());
    }

    const QJsonDocument doc(tasksArray);
    const QString filePath = m_savePath + QStringLiteral("/tasks.json");
    const QString tmpPath = filePath + QStringLiteral(".tmp");

    QFile tmpFile(tmpPath);
    if (tmpFile.open(QIODevice::WriteOnly)) {
        tmpFile.write(doc.toJson(QJsonDocument::Compact));
        tmpFile.close();

        QFile::remove(filePath);
        if (!QFile::rename(tmpPath, filePath)) {
            LOG_ERROR("TaskManager", QStringLiteral("Failed to save tasks: rename failed"));
            QFile::remove(tmpPath);
        } else {
            LOG_DEBUG("TaskManager", QStringLiteral("Saved %1 tasks").arg(m_tasks.size()));
        }
    } else {
        LOG_ERROR("TaskManager", QStringLiteral("Failed to open file for writing: %1").arg(tmpPath));
    }
}

void TaskManager::loadTasks() {
    m_loading = true;

    QFile file(m_savePath + QStringLiteral("/tasks.json"));
    if (file.open(QIODevice::ReadOnly)) {
        if (file.size() > MAX_IMPORT_SIZE) {
            LOG_WARNING("TaskManager", QStringLiteral("Tasks file too large, skipping load"));
            file.close();
            m_loading = false;
            return;
        }

        const QByteArray data = file.readAll();
        file.close();

        const QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isArray()) {
            LOG_WARNING("TaskManager", QStringLiteral("Invalid tasks file format"));
            m_loading = false;
            return;
        }

        const QJsonArray tasksArray = doc.array();
        m_tasks.reserve(tasksArray.size());

        for (const QJsonValue &value : tasksArray) {
            if (!value.isObject()) continue;
            const QJsonObject json = value.toObject();
            if (!validateTaskJson(json)) continue;

            Task *task = Task::fromJson(json, this);
            m_tasks.append(task);
            m_taskHash[task->id()] = task;
        }

        rebuildScheduledList();
        updateCategoryTaskCounts();

        emit tasksChanged();
        emit scheduledTasksChanged();
        
        LOG_INFO("TaskManager", QStringLiteral("Loaded %1 tasks").arg(m_tasks.size()));
    }

    m_loading = false;
}

bool TaskManager::exportTasks(const QUrl &fileUrl) {
    const QString filePath = fileUrl.toLocalFile();
    if (filePath.isEmpty()) return false;

    QJsonArray tasksArray;
    // Note: QJsonArray does not support reserve in Qt6
    for (const Task *task : m_tasks) {
        tasksArray.append(task->toJson());
    }

    QJsonArray categoriesArray;
    // Note: QJsonArray does not support reserve in Qt6
    for (const Category *category : m_categories) {
        categoriesArray.append(category->toJson());
    }

    QJsonObject root;
    root[QStringLiteral("version")] = QStringLiteral("1.1");
    root[QStringLiteral("exportDate")] = QDateTime::currentDateTime().toString(Qt::ISODate);
    root[QStringLiteral("taskCount")] = tasksArray.size();
    root[QStringLiteral("categoryCount")] = categoriesArray.size();
    root[QStringLiteral("tasks")] = tasksArray;
    root[QStringLiteral("categories")] = categoriesArray;

    const QJsonDocument doc(root);
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson(QJsonDocument::Indented));
        file.close();
        emit exportFinished(true, QStringLiteral("导出成功: ") + filePath);
        LOG_INFO("TaskManager", QStringLiteral("Exported %1 tasks to %2").arg(m_tasks.size()).arg(filePath));
        return true;
    }
    emit exportFinished(false, QStringLiteral("导出失败: 无法写入文件"));
    LOG_ERROR("TaskManager", QStringLiteral("Export failed: cannot write to %1").arg(filePath));
    return false;
}

bool TaskManager::importTasks(const QUrl &fileUrl) {
    const QString filePath = fileUrl.toLocalFile();
    if (filePath.isEmpty()) return false;

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        emit importFinished(false, QStringLiteral("导入失败: 无法读取文件"));
        return false;
    }

    if (file.size() > MAX_IMPORT_SIZE) {
        file.close();
        emit importFinished(false, QStringLiteral("导入失败: 文件过大 (最大 10MB)"));
        return false;
    }

    const QByteArray data = file.readAll();
    file.close();

    const QJsonDocument doc = QJsonDocument::fromJson(data);
    if (doc.isNull()) {
        emit importFinished(false, QStringLiteral("导入失败: JSON 格式错误"));
        return false;
    }

    QJsonArray tasksArray;
    QJsonArray categoriesArray;

    if (doc.isObject()) {
        const QJsonObject root = doc.object();
        if (root.contains(QStringLiteral("tasks"))) {
            tasksArray = root.value(QStringLiteral("tasks")).toArray();
        }
        if (root.contains(QStringLiteral("categories"))) {
            categoriesArray = root.value(QStringLiteral("categories")).toArray();
        }
    } else if (doc.isArray()) {
        tasksArray = doc.array();
    } else {
        emit importFinished(false, QStringLiteral("导入失败: 文件格式不正确"));
        return false;
    }

    int importedTasks = 0;
    int importedCategories = 0;

    // Import categories first
    for (const QJsonValue &value : categoriesArray) {
        if (m_categories.size() >= MAX_CATEGORIES) break;
        if (!value.isObject()) continue;
        Category *category = Category::fromJson(value.toObject(), this);
        m_categories.append(category);
        m_categoryHash[category->id()] = category;
        importedCategories++;
    }

    // Import tasks
    for (const QJsonValue &value : tasksArray) {
        if (m_tasks.size() >= MAX_TASKS) break;
        if (!value.isObject()) continue;
        const QJsonObject json = value.toObject();
        if (!validateTaskJson(json)) continue;

        Task *task = Task::fromJson(json, this);
        task->setId(QUuid::createUuid().toString(QUuid::WithoutBraces));
        m_tasks.append(task);
        m_taskHash[task->id()] = task;
        importedTasks++;
    }

    rebuildScheduledList();
    updateCategoryTaskCounts();
    
    m_filterCacheValid = false;
    emit tasksChanged();
    emit scheduledTasksChanged();
    emit categoriesChanged();
    scheduleSave();
    saveCategories();

    QString message = QStringLiteral("导入成功: 共导入 %1 个任务和 %2 个分类")
        .arg(importedTasks).arg(importedCategories);
    emit importFinished(true, message);
    LOG_INFO("TaskManager", message);
    return true;
}

// ========== Static QQmlListProperty callbacks ==========

void TaskManager::appendTask(QQmlListProperty<Task> *list, Task *task) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (manager && task) {
        manager->m_tasks.append(task);
        manager->m_taskHash[task->id()] = task;
    }
}

qsizetype TaskManager::taskCount(QQmlListProperty<Task> *list) {
    auto *manager = static_cast<TaskManager*>(list->object);
    return manager ? manager->m_tasks.count() : 0;
}

Task* TaskManager::task(QQmlListProperty<Task> *list, qsizetype index) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (!manager || index < 0 || index >= manager->m_tasks.size()) return nullptr;
    return manager->m_tasks.at(index);
}

void TaskManager::clearTasks(QQmlListProperty<Task> *list) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (!manager) return;
    manager->m_taskHash.clear();
    manager->m_tasks.clear();
}

void TaskManager::appendCategory(QQmlListProperty<Category> *list, Category *category) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (manager && category) {
        manager->m_categories.append(category);
        manager->m_categoryHash[category->id()] = category;
    }
}

qsizetype TaskManager::categoryCount(QQmlListProperty<Category> *list) {
    auto *manager = static_cast<TaskManager*>(list->object);
    return manager ? manager->m_categories.count() : 0;
}

Category* TaskManager::category(QQmlListProperty<Category> *list, qsizetype index) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (!manager || index < 0 || index >= manager->m_categories.size()) return nullptr;
    return manager->m_categories.at(index);
}

void TaskManager::clearCategories(QQmlListProperty<Category> *list) {
    auto *manager = static_cast<TaskManager*>(list->object);
    if (!manager) return;
    manager->m_categoryHash.clear();
    manager->m_categories.clear();
}