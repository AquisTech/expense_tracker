class RecurrenceRule < ApplicationRecord
  serialize :rules
  has_many :occurrences, dependent: :destroy
  belongs_to :transaction_purpose

  after_create :create_occurrences

  TYPES = ['Daily', 'Weekly', 'Monthly', 'Yearly']

  def create_occurrences
    case type
    when 'Daily'
      create_occurrence(interval)
    when 'Weekly'
      rules.each { |day_of_week| create_occurrence(day_of_week) }
    when 'Monthly'
      if rules.is_a?(Hash)
        rules.each do |day_of_week, week_numbers|
          week_numbers.each { |week_number| create_occurrence(day_of_week, weeks: week_number) }
        end
      else
        rules.each { |day_of_month| create_occurrence(day_of_month) }
      end
    when 'Yearly'
      rules.each do |month_number, days_of_month|
        days_of_month.each { |day_of_month| create_occurrence(day_of_month, months: month_number)}
      end
    else
      raise 'Invalid Rule. TODO: Support custom rule'
    end
  end

  TYPES.each do |recurrence_type|
    define_method "#{recurrence_type.downcase}?" do
      type == recurrence_type
    end
  end

  def monthly_days_of_month?
    type == 'Monthly' && rules.is_a?(Array)
  end

  def monthly_days_of_week?
    type == 'Monthly' && rules.is_a?(Hash)
  end

  def yearly_days_of_month?
    type == 'Yearly' && rules.values.first.is_a?(Array)
  end

  def yearly_days_of_week?
    type == 'Yearly' && rules.values.first.is_a?(Hash)
  end

  def duration_bound?
    starts_on?
  end

  def count_bound?
    count?
  end

  def create_occurrence(days, weeks: nil, months: nil)
    o = occurrences.build
    o.recurrence_type = type
    o.interval = interval
    o.days = days
    o.weeks = weeks
    o.months = months
    o.starts_on = nil
    o.ends_on = nil
    o.count = nil
    o.save
  end

  def humanize
    msg = case type
    when 'Daily'
      interval == 1 ? 'Daily' : "Every #{interval} days"
    when 'Weekly'
      s = interval == 1 ? 'Weekly' : "Every #{interval} weeks"
      s += " on #{day_names(rules.map(&:to_i))}"
    when 'Monthly'
      s = { 1 => 'Monthly', 3 => 'Quarterly', 6 => 'Half Yearly' }[interval] || "Every #{interval} months"
      s += " on #{ordinalized_day_numbers(rules)} #{'day'.pluralize(rules.count)}" if rules.is_a?(Array)
      s += " on #{weekly_rules_text(rules)}" if rules.is_a?(Hash)
      s += ' of the month'
    when 'Yearly'
      s = interval == 1 ? 'Yearly' : "Every #{interval} years"
      s += " on #{yearly_rules_text(rules)} of the year"
    else
      'Invalid Rule. TODO: Support custom rule'
    end
    msg += " from #{starts_on} to #{ends_on}" if duration_bound?
    msg += ' ' + ({ 1 => 'once', 2 => 'twice', 3 => 'thrice' }[count] || "#{count} times") if count_bound?
    msg
  end

  def day_names(day_numbers)
    case day_numbers
    when [0, 6] then 'Weekends'
    when [1, 2, 3, 4, 5] then 'Weekdays'
    else
      day_numbers.map { |i| "#{Date::DAYNAMES[i]}s" }.to_sentence
    end
  end

  def month_names(month_numbers)
    month_numbers.map { |i| "#{Date::MONTHNAMES[i]}" }.to_sentence
  end

  def ordinalized_day_numbers(day_numbers)
    day_numbers.to_ordinalized_collection_sentence
  end

  def weekly_rules_text(rules_hash)
    if rules_hash.values.count > 1 && rules_hash.values.uniq.count == 1
      "#{day_names(rules_hash.keys.map(&:to_i))} of #{rules_hash.values.first.to_ordinalized_collection_sentence} #{'week'.pluralize(rules_hash.values.first.count)}"
    else
      rules_hash.map do |day_number, week_numbers|
        "#{week_numbers.to_ordinalized_collection_sentence(two_words_connector: ', ', last_word_connector: ', ')} #{Date::DAYNAMES[day_number.to_i].pluralize(week_numbers.count)}"
      end.to_sentence
    end
  end

  def yearly_rules_text(rules_hash)
    if rules_hash.values.first.is_a?(Array)
      if rules_hash.values.count > 1 && rules_hash.values.uniq.count == 1
        "#{rules_hash.values.first.to_ordinalized_collection_sentence} of #{month_names(rules_hash.keys)}"
      else
        rules_hash.map do |month_number, day_numbers|
          "#{day_numbers.to_ordinalized_collection_sentence(two_words_connector: ', ', last_word_connector: ', ')} #{Date::MONTHNAMES[month_number]}"
        end.to_sentence
      end
    else
      rules_hash.map do |month_number, weekly_hash|
        "#{weekly_rules_text(weekly_hash)} of #{Date::MONTHNAMES[month_number]}"
      end.to_sentence
    end
  end
end
