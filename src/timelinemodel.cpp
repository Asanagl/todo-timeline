#include "timelinemodel.h"

TimelineModel::TimelineModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_currentDate(QDate::currentDate())
{
}

int TimelineModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return HOURS_IN_DAY;
}

QVariant TimelineModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= HOURS_IN_DAY)
        return QVariant();

    int hour = index.row();

    switch (role) {
    case HourRole:
        return hour;
    case TimeStringRole:
        return timeStringForHour(hour);
    case IsCurrentHourRole:
        return isCurrentHour(hour);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TimelineModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[HourRole] = "hour";
    roles[TimeStringRole] = "timeString";
    roles[IsCurrentHourRole] = "isCurrentHour";
    return roles;
}

QDate TimelineModel::currentDate() const
{
    return m_currentDate;
}

void TimelineModel::setCurrentDate(const QDate &date)
{
    if (m_currentDate != date) {
        m_currentDate = date;
        emit currentDateChanged();
        // 重新加载数据
        beginResetModel();
        endResetModel();
    }
}

int TimelineModel::hourCount() const
{
    return HOURS_IN_DAY;
}

QString TimelineModel::timeStringForHour(int hour) const
{
    if (hour < 0 || hour >= HOURS_IN_DAY)
        return QString();

    return QTime(hour, 0).toString("HH:mm");
}

bool TimelineModel::isCurrentHour(int hour) const
{
    QTime currentTime = QTime::currentTime();
    return m_currentDate == QDate::currentDate() && currentTime.hour() == hour;
}

QDate TimelineModel::dateForHour(int hour) const
{
    Q_UNUSED(hour)
    return m_currentDate;
}
