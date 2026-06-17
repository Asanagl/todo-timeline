#include "taskmanager.h"

// Task 实现
Task::Task(QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_completed(false)
    , m_priority(0)
    , m_color("#4A90D9")
    , m_scheduled(false)
{
}

Task::Task(const QString &title, const QString &description, QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString(QUuid::WithoutBraces))
    , m_title(title)
    , m_description(description)
    , m_completed(false)
    , m_priority(0)
    , m_color("#4A90D9")
    , m_scheduled(false)
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
    if (m_title != title) {
        m_title = title;
        emit titleChanged();
    }
}

QString Task::description() const { return m_description; }
void Task::setDescription(const QString &description) {
    if (m_description != description) {
        m_description = description;
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
    if (m_priority != priority) {
        m_priority = priority;
        emit priorityChanged();
    }
}

QString Task::color() const { return m_color; }
void Task::setColor(const QString &color) {
    if (m_color != color) {
        m_color = color;
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

QJsonObject Task::toJson() const {
    QJsonObject json;
    json["id"] = m_id;
    json["title"] = m_title;
    json["description"] = m_description;
    json["startTime"] = m_startTime.toString(Qt::ISODate);
    json["endTime"] = m_endTime.toString(Qt::ISODate);
    json["completed"] = m_completed;
    json["priority"] = m_priority;
    json["color"] = m_color;
    json["scheduled"] = m_scheduled;
    return json;
}

Task* Task::fromJson(const QJsonObject &json, QObject *parent) {
    Task *task = new Task(parent);
    task->m_id = json["id"].toString();
    task->m_title = json["title"].toString();
    task->m_description = json["description"].toString();
    task->m_startTime = QDateTime::fromString(json["startTime"].toString(), Qt::ISODate);
    task->m_endTime = QDateTime::fromString(json["endTime"].toString(), Qt::ISODate);
    task->m_completed = json["completed"].toBool();
    task->m_priority = json["priority"].toInt();
    task->m_color = json["color"].toString();
    task->m_scheduled = json["scheduled"].toBool();
    return task;
}

// TaskManager 实现
TaskManager::TaskManager(QObject *parent)
    : QObject(parent)
{
    m_savePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(m_savePath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    loadTasks();
}

QQmlListProperty<Task> TaskManager::tasks() {
    return QQmlListProperty<Task>(this, this,
        &TaskManager::appendTask,
        &TaskManager::taskCount,
        &TaskManager::task,
        &TaskManager::clearTasks);
}

QQmlListProperty<Task> TaskManager::scheduledTasks() {
    return QQmlListProperty<Task>(this, this,
        nullptr,
        [](QQmlListProperty<Task> *list) -> int {
            TaskManager *manager = static_cast<TaskManager*>(list->data);
            return manager->m_scheduledTasks.count();
        },
        [](QQmlListProperty<Task> *list, int index) -> Task* {
            TaskManager *manager = static_cast<TaskManager*>(list->data);
            return manager->m_scheduledTasks.at(index);
        },
        nullptr);
}

void TaskManager::addTask(const QString &title, const QString &description) {
    Task *task = new Task(title, description, this);
    m_tasks.append(task);
    emit tasksChanged();
    emit taskAdded(task);
    saveTasks();
}

void TaskManager::removeTask(const QString &taskId) {
    for (int i = 0; i < m_tasks.size(); ++i) {
        if (m_tasks[i]->id() == taskId) {
            Task *task = m_tasks.takeAt(i);
            emit taskRemoved(taskId);

            // 也从计划列表中移除
            for (int j = 0; j < m_scheduledTasks.size(); ++j) {
                if (m_scheduledTasks[j]->id() == taskId) {
                    m_scheduledTasks.takeAt(j);
                    emit scheduledTasksChanged();
                    break;
                }
            }

            delete task;
            emit tasksChanged();
            saveTasks();
            return;
        }
    }
}

void TaskManager::updateTask(const QString &taskId, const QString &title, const QString &description) {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            task->setTitle(title);
            task->setDescription(description);
            saveTasks();
            return;
        }
    }
}

void TaskManager::updateTaskFull(const QString &taskId, const QString &title, const QString &description,
                                  int priority, const QString &color) {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            task->setTitle(title);
            task->setDescription(description);
            task->setPriority(priority);
            task->setColor(color);
            emit tasksChanged();
            saveTasks();
            return;
        }
    }
}

QString TaskManager::filterText() const { return m_filterText; }

void TaskManager::setFilterText(const QString &text) {
    if (m_filterText != text) {
        m_filterText = text;
        emit filterTextChanged();
        emit tasksChanged();
    }
}

Task* TaskManager::findTask(const QString &taskId) const {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            return task;
        }
    }
    return nullptr;
}

int TaskManager::taskCountFiltered() const {
    if (m_filterText.isEmpty()) return m_tasks.size();
    int count = 0;
    for (const Task *task : m_tasks) {
        if (task->title().contains(m_filterText, Qt::CaseInsensitive) ||
            task->description().contains(m_filterText, Qt::CaseInsensitive)) {
            count++;
        }
    }
    return count;
}

void TaskManager::toggleTaskCompletion(const QString &taskId) {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            task->setCompleted(!task->completed());
            saveTasks();
            return;
        }
    }
}

void TaskManager::scheduleTask(const QString &taskId, const QDateTime &startTime, const QDateTime &endTime) {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            task->setStartTime(startTime);
            task->setEndTime(endTime);
            task->setScheduled(true);

            // 添加到计划列表
            if (!m_scheduledTasks.contains(task)) {
                m_scheduledTasks.append(task);
                emit scheduledTasksChanged();
            }

            emit taskScheduled(task);
            saveTasks();
            return;
        }
    }
}

void TaskManager::unscheduleTask(const QString &taskId) {
    for (Task *task : m_tasks) {
        if (task->id() == taskId) {
            task->setScheduled(false);
            task->setStartTime(QDateTime());
            task->setEndTime(QDateTime());

            // 从计划列表中移除
            for (int i = 0; i < m_scheduledTasks.size(); ++i) {
                if (m_scheduledTasks[i]->id() == taskId) {
                    m_scheduledTasks.takeAt(i);
                    emit scheduledTasksChanged();
                    break;
                }
            }

            emit taskUnscheduled(taskId);
            saveTasks();
            return;
        }
    }
}

void TaskManager::moveTask(const QString &taskId, const QDateTime &newStartTime) {
    for (Task *task : m_scheduledTasks) {
        if (task->id() == taskId) {
            qint64 duration = task->startTime().secsTo(task->endTime());
            task->setStartTime(newStartTime);
            task->setEndTime(newStartTime.addSecs(duration));
            saveTasks();
            return;
        }
    }
}

void TaskManager::saveTasks() {
    QJsonArray tasksArray;
    for (const Task *task : m_tasks) {
        tasksArray.append(task->toJson());
    }

    QJsonDocument doc(tasksArray);
    QFile file(m_savePath + "/tasks.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }
}

void TaskManager::loadTasks() {
    QFile file(m_savePath + "/tasks.json");
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonArray tasksArray = doc.array();

        for (const QJsonValue &value : tasksArray) {
            QJsonObject json = value.toObject();
            Task *task = Task::fromJson(json, this);
            m_tasks.append(task);

            if (task->scheduled()) {
                m_scheduledTasks.append(task);
            }
        }

        emit tasksChanged();
        emit scheduledTasksChanged();
    }
}

bool TaskManager::exportTasks(const QUrl &fileUrl) {
    QString filePath = fileUrl.toLocalFile();
    if (filePath.isEmpty()) return false;

    QJsonArray tasksArray;
    for (const Task *task : m_tasks) {
        tasksArray.append(task->toJson());
    }

    QJsonObject root;
    root["version"] = "1.0";
    root["exportDate"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    root["taskCount"] = tasksArray.size();
    root["tasks"] = tasksArray;

    QJsonDocument doc(root);
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson(QJsonDocument::Indented));
        file.close();
        emit exportFinished(true, "导出成功: " + filePath);
        return true;
    }
    emit exportFinished(false, "导出失败: 无法写入文件");
    return false;
}

bool TaskManager::importTasks(const QUrl &fileUrl) {
    QString filePath = fileUrl.toLocalFile();
    if (filePath.isEmpty()) return false;

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        emit importFinished(false, "导入失败: 无法读取文件");
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject root = doc.object();

    QJsonArray tasksArray;
    if (root.contains("tasks")) {
        tasksArray = root["tasks"].toArray();
    } else if (doc.isArray()) {
        tasksArray = doc.array();
    } else {
        emit importFinished(false, "导入失败: 文件格式不正确");
        return false;
    }

    int imported = 0;
    for (const QJsonValue &value : tasksArray) {
        QJsonObject json = value.toObject();
        Task *task = Task::fromJson(json, this);
        // 生成新ID避免冲突
        task->setProperty("id", QUuid::createUuid().toString(QUuid::WithoutBraces));
        m_tasks.append(task);
        if (task->scheduled()) {
            m_scheduledTasks.append(task);
        }
        imported++;
    }

    emit tasksChanged();
    emit scheduledTasksChanged();
    saveTasks();
    emit importFinished(true, QString("导入成功: 共导入 %1 个任务").arg(imported));
    return true;
}

void TaskManager::appendTask(QQmlListProperty<Task> *list, Task *task) {
    TaskManager *manager = static_cast<TaskManager*>(list->data);
    manager->m_tasks.append(task);
}

int TaskManager::taskCount(QQmlListProperty<Task> *list) {
    TaskManager *manager = static_cast<TaskManager*>(list->data);
    return manager->m_tasks.count();
}

Task* TaskManager::task(QQmlListProperty<Task> *list, int index) {
    TaskManager *manager = static_cast<TaskManager*>(list->data);
    return manager->m_tasks.at(index);
}

void TaskManager::clearTasks(QQmlListProperty<Task> *list) {
    TaskManager *manager = static_cast<TaskManager*>(list->data);
    qDeleteAll(manager->m_tasks);
    manager->m_tasks.clear();
}
