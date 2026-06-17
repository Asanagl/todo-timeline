#ifndef TIMELINEMODEL_H
#define TIMELINEMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QVector>

class TimelineModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QDate currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(int hourCount READ hourCount CONSTANT)

public:
    enum TimelineRoles {
        HourRole = Qt::UserRole + 1,
        TimeStringRole,
        IsCurrentHourRole
    };

    explicit TimelineModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QDate currentDate() const;
    void setCurrentDate(const QDate &date);

    int hourCount() const;

    Q_INVOKABLE QString timeStringForHour(int hour) const;
    Q_INVOKABLE bool isCurrentHour(int hour) const;
    Q_INVOKABLE QDate dateForHour(int hour) const;

signals:
    void currentDateChanged();

private:
    QDate m_currentDate;
    static const int HOURS_IN_DAY = 24;
};

#endif // TIMELINEMODEL_H
