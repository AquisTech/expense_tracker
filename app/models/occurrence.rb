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
        SELECT * FROM occurrences
        WHERE
          -- Daily
          (recurrence_type = 'Daily' AND (((:date - DATE(`starts_on`)) % `interval`) = 0))
          OR
          -- Monthly day of month
          (recurrence_type = 'Monthly' AND weeks is NULL AND (DAY(:date) = DAY(starts_on)) AND (((:date - DATE(`starts_on`)) % `interval`) = 0))
          OR
          -- Monthly day of week
          (recurrence_type = 'Monthly' AND weeks is NOT NULL AND (DAY(:date) = DAY(starts_on)) AND (((:date - DATE(`starts_on`)) % `interval`) = 0))
      },
      date: date
    ])
  end
end
