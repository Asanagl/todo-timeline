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
#include <QFileDialog>

class Task : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QDateTime startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(QDateTime endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)
    Q_PROPERTY(bool completed READ completed WRITE setCompleted NOTIFY completedChanged)
    Q_PROPERTY(int priority READ priority WRITE setPriority NOTIFY priorityChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(bool scheduled READ scheduled WRITE setScheduled NOTIFY scheduledChanged)

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

    QJsonObject toJson() const;
    static Task* fromJson(const QJsonObject &json, QObject *parent = nullptr);

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
};

class TaskManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Task> tasks READ tasks NOTIFY tasksChanged)
    Q_PROPERTY(QQmlListProperty<Task> scheduledTasks READ scheduledTasks NOTIFY scheduledTasksChanged)
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)

public:
    explicit TaskManager(QObject *parent = nullptr);

    QQmlListProperty<Task> tasks();
    QQmlListProperty<Task> scheduledTasks();

    QString filterText() const;
    void setFilterText(const QString &text);

    Q_INVOKABLE void addTask(const QString &title, const QString &description);
    Q_INVOKABLE void removeTask(const QString &taskId);
    Q_INVOKABLE void updateTask(const QString &taskId, const QString &title, const QString &description);
    Q_INVOKABLE void updateTaskFull(const QString &taskId, const QString &title, const QString &description,
                                     int priority, const QString &color);
    Q_INVOKABLE void toggleTaskCompletion(const QString &taskId);
    Q_INVOKABLE void scheduleTask(const QString &taskId, const QDateTime &startTime, const QDateTime &endTime);
    Q_INVOKABLE void unscheduleTask(const QString &taskId);
    Q_INVOKABLE void moveTask(const QString &taskId, const QDateTime &newStartTime);

    Q_INVOKABLE Task* findTask(const QString &taskId) const;
    Q_INVOKABLE int taskCountFiltered() const;

    Q_INVOKABLE void saveTasks();
    Q_INVOKABLE void loadTasks();
    Q_INVOKABLE bool exportTasks(const QUrl &fileUrl);
    Q_INVOKABLE bool importTasks(const QUrl &fileUrl);

signals:
    void tasksChanged();
    void scheduledTasksChanged();
    void filterTextChanged();
    void taskAdded(Task *task);
    void taskRemoved(const QString &taskId);
    void taskScheduled(Task *task);
    void taskUnscheduled(const QString &taskId);
    void exportFinished(bool success, const QString &message);
    void importFinished(bool success, const QString &message);

private:
    static void appendTask(QQmlListProperty<Task> *list, Task *task);
    static int taskCount(QQmlListProperty<Task> *list);
    static Task* task(QQmlListProperty<Task> *list, int index);
    static void clearTasks(QQmlListProperty<Task> *list);

    QList<Task*> m_tasks;
    QList<Task*> m_scheduledTasks;
    QString m_savePath;
    QString m_filterText;
};

#endif // TASKMANAGER_H
