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
    start_end_count_conditions = "(
            starts_on <= :date AND
            (
              (ends_on IS NULL AND count IS NULL) OR
              (ends_on >= :date AND count IS NULL) -- OR
              -- (ends_on IS NULL AND count < exhausted_count) OR
              -- (ends_on >= :date OR count <> exhausted_count) -- ends_on and count both present so whichever is over consider it end
            )
          )"
    daily = "-- Daily
            (recurrence_type = 'Daily' AND (#{DATE_DIFF(':date', 'starts_on')} % #{INTERVAL_COLUMN()}) = 0)"
    weekly = "-- Weekly
            (recurrence_type = 'Weekly' AND (days = (#{DAY_OF_WEEK(':date')} - 1)) AND (#{DATE_DIFF(':date', 'starts_on')} % (#{INTERVAL_COLUMN()} * 7)) = 0)"
    monthly_day_of_month = "-- Monthly day of month
            (
              recurrence_type = 'Monthly' AND
              weeks IS NULL AND
              days IN (#{DAY_OF_MONTH(':date')}) AND
              #{PERIOD_DIFF_IN_MONTHS(':date', 'starts_on')} % #{INTERVAL_COLUMN()} = 0
            )"
    monthly_day_of_week = "-- Monthly day of week
            -- create funct for week of month
            (
              recurrence_type = 'Monthly' AND
              weeks IS NOT NULL AND
              days = (#{DAY_OF_WEEK(':date')} - 1) AND
              weeks IN (#{WEEK_OF_MONTH(':date')}) AND
              #{PERIOD_DIFF_IN_MONTHS(':date', 'starts_on')} % #{INTERVAL_COLUMN()} = 0
            )"
    yearly_day_of_month = "-- Yearly day of month
            (
              recurrence_type = 'Yearly' AND
              weeks IS NULL AND
              months = #{MONTH(':date')} AND
              days IN (#{DAY_OF_MONTH(':date')}) AND
              #{PERIOD_DIFF_IN_YEARS(':date', 'starts_on')} % #{INTERVAL_COLUMN()} = 0
            )"
    yearly_day_of_week = "-- Yearly day of week
            (
              recurrence_type = 'Yearly' AND
              weeks IS NOT NULL AND
              months = #{MONTH(':date')} AND
              days = (#{DAY_OF_WEEK(':date')} - 1) AND
              weeks IN (#{WEEK_OF_MONTH(':date')}) AND
              #{PERIOD_DIFF_IN_YEARS(':date', 'starts_on')} % #{INTERVAL_COLUMN()} = 0
            )"
    Occurrence.find_by_sql([
      %Q{
        SELECT *,
        #{DAY(':date')} a1,
        #{LAST_DAY(':date')} a2,
        #{DATE_DIFF(':date', 'starts_on')} a3,
        #{DAY_OF_WEEK(':date')} a4,
        #{DAY_OF_MONTH(':date')} a5,
        #{WEEK(':date')} a6,
        #{WEEK_OF_FIRST_DAY_OF_MONTH(':date')} a7,
        #{WEEK_OF_LAST_DAY_OF_MONTH(':date')} a8,
        #{WEEK_OF_MONTH(':date')} a9,
        #{MONTH(':date')} a10,
        #{PERIOD_DIFF_IN_MONTHS(':date', 'starts_on')} a11,
        #{PERIOD_DIFF_IN_YEARS(':date', 'starts_on')} a12
        FROM occurrences
        WHERE (
          #{daily}
          OR
          #{weekly}
          OR
          #{monthly_day_of_month}
          OR
          #{monthly_day_of_week}
          OR
          #{yearly_day_of_month}
          OR
          #{yearly_day_of_week}
        )
        AND
        #{start_end_count_conditions}
      },
      date: date
    ])
  end

  def calculate_starts_on(date=nil)
    return nil if date.nil?
    case recurrence_type
    when 'Daily'
      date
    when 'Weekly'
      date.date_of_next_wday(days)
    when 'Monthly'
      if weeks.nil?
        date.date_of_next_nth_day(days)
      else
        date.date_of_next_nth_wday(weeks, days)
      end
    when 'Yearly'
      if weeks.nil?
        date.date_of_next_nth_month_day(months, days)
      else
        date.date_of_next_nth_month_wday(months, weeks, days)
      end
    else
      # TODO: #FutureScope Add custom rule
      raise 'Invalid Rule. TODO: Support custom rule'
    end
  end

  def calculate_ends_on(date=nil)
    return nil if date.nil?
    case recurrence_type
    when 'Daily'
      date
    when 'Weekly'
      date.date_of_last_wday(days)
    when 'Monthly'
      if weeks.nil?
        date.date_of_last_nth_day(days)
      else
        date.date_of_last_nth_wday(weeks, days)
      end
    when 'Yearly'
      if weeks.nil?
        date.date_of_last_nth_month_day(months, days)
      else
        date.date_of_last_nth_month_wday(months, weeks, days)
      end
    else
      # TODO: #FutureScope Add custom rule
      raise 'Invalid Rule. TODO: Support custom rule'
    end
  end
end
