class Occurrence < ApplicationRecord
  belongs_to :recurrence_rule

  validates :recurrence_type, presence: true, inclusion: { in: RecurrenceRule::TYPES }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :days, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: -1 }
  validates :weeks, numericality: { only_integer: true, greater_than_or_equal_to: -1 }, allow_nil: true
  validates :months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :count, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :starts_on, presence: true
  validates :ends_on, timeliness: { after: :starts_on }, allow_nil: true
end
