class Occurrence < ApplicationRecord
  # TODO: Rename columns to singularised
  belongs_to :recurrence_rule
  delegate :transaction_purpose, to: :recurrence_rule
  delegate :humanize, to: :recurrence_rule

  validates :recurrence_type, presence: true, inclusion: { in: RecurrenceRule::TYPES }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :days, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -1 }
  validates :weeks, numericality: { only_integer: true, greater_than_or_equal_to: -1 }, allow_nil: true
  validates :months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :starts_on, presence: true, timeliness: true
  validates :ends_on, timeliness: { after: :starts_on }, allow_nil: true

  def self.for(date)
    # TODO: Make week starting from monday. Change week function parameter accordingly
    daily = "(recurrence_type = 'Daily' AND (DATEDIFF(:date, starts_on) % `interval`) = 0)"
    weekly = "(recurrence_type = 'Weekly' AND (days = (DAYOFWEEK(:date) - 1)))"
    monthly_day_of_month = "(
            recurrence_type = 'Monthly' AND
            weeks IS NULL AND
            (days = DAY(:date) OR days = IF(LAST_DAY(:date) = :date, -1, NULL))
          )"
    monthly_day_of_week = "(
            recurrence_type = 'Monthly' AND
            weeks IS NOT NULL AND
            days = (DAYOFWEEK(:date) - 1) AND
            (
              weeks IN (
                WEEK(:date, 2) - WEEK(:date - INTERVAL DAY(:date) - 1 DAY, 2) + 1,
                IF(WEEK(:date, 2) - WEEK(LAST_DAY(:date), 2) = 0, -1, NULL)
              )
            )
          )"
    yearly_day_of_month = "(
            recurrence_type = 'Yearly' AND
            weeks IS NULL AND
            months = MONTH(:date) AND
            (days = DAY(:date) OR days = IF(LAST_DAY(:date) = :date, -1, NULL))
          )"
    yearly_day_of_week = "(
            recurrence_type = 'Yearly' AND
            weeks IS NOT NULL AND
            months = MONTH(:date) AND
            days = (DAYOFWEEK(:date) - 1) AND
            (
              weeks IN (
                WEEK(:date, 2) - WEEK(:date - INTERVAL DAY(:date) - 1 DAY, 2) + 1,
                IF(WEEK(:date, 2) - WEEK(LAST_DAY(:date), 2) = 0, -1, NULL)
              )
            )
          )"
    Occurrence.find_by_sql([
      %Q{
        SELECT *,
        DAY(:date) d,
        WEEK(:date) w,
        :date dt,
        DATE_FORMAT(`starts_on`, '%Y-%m-%d') sd,
        (:date - DATE_FORMAT(`starts_on`, '%Y-%m-%d')) diff,
        ('2018-09-01' - "2018-02-18") diff2,
        DATEDIFF('2018-09-01', "2018-02-18") diff3,
        DATEDIFF(:date, starts_on) diff4,
        DAYOFWEEK(:date) - 1 dow,
        (WEEK(:date, 2) - WEEK(:date - INTERVAL DAY(:date) - 1 DAY, 2) + 1) wom,
        EXTRACT(YEAR_MONTH FROM :date) ym,
        MONTH(:date) mon
        FROM occurrences
        WHERE
          -- Daily
          -- checked + starts_on and ends_on and count cond to be added
          #{daily}
          OR
          -- Weekly
          -- checked + starts_on and ends_on and count and interval cond to be added
          #{weekly}
          OR
          -- Monthly day of month
          -- checked + starts_on and ends_on and count and interval cond to be added
          #{monthly_day_of_month}
          OR
          -- Monthly day of week
          -- checked + starts_on and ends_on and count and interval cond to be added + create funct for week of month
          #{monthly_day_of_week}
          OR
          -- Yearly day of month
          #{yearly_day_of_month}
          OR
          -- Yearly day of week
          #{yearly_day_of_week}
      },
      date: date
    ])
  end
end
