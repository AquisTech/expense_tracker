class Occurrence < ApplicationRecord
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
        EXTRACT(YEAR_MONTH FROM :date) ym
        FROM occurrences
        WHERE
          -- Daily
          (recurrence_type = 'Daily' AND (DATEDIFF(:date, starts_on) % `interval`) = 0) -- checked + starts_on and ends_on and count cond to be added
          OR
          -- Weekly
          (recurrence_type = 'Weekly' AND ((DAYOFWEEK(:date) - 1) = days)) -- checked + starts_on and ends_on and count and interval cond to be added
          OR
          -- Monthly day of month
          (recurrence_type = 'Monthly' AND weeks IS NULL AND (DAY(:date) = days)) -- checked + interval needs fix
          -- OR
          -- Monthly day of week
          -- (recurrence_type = 'Monthly' AND weeks IS NOT NULL AND (DAY(:date) = DAY(starts_on)) AND (((:date - DATE(`starts_on`)) % `interval`) = 0))
          -- OR
          -- Yearly day of month
          -- Yearly day of week
      },
      date: date
    ])
  end
end
