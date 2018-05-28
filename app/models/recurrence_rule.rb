class RecurrenceRule < ApplicationRecord

  TYPES = ['Daily', 'Weekly', 'Monthly', 'Yearly']

  serialize :rules

  validates :type, presence: true, inclusion: { in: TYPES }
  validates :interval, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :count, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :rules, presence: true, unless: :daily?
  validates :rules, rules_hash_format: true
  validates :starts_on, presence: true, timeliness: true
  validates :ends_on, timeliness: { after: :starts_on }, allow_nil: true

  after_create :create_occurrences

  has_many :occurrences, dependent: :destroy
  belongs_to :transaction_purpose # TODO: Remove transaction_purpose_id from RecurrenceRule

  # Workaround to get forms working with STI child object
  def self.inherited(child)
    child.instance_eval do
      def model_name
        RecurrenceRule.model_name
      end
    end
    super
  end

  TYPES.each do |recurrence_type|
    define_method "#{recurrence_type.downcase}?" do
      type == recurrence_type
    end
  end

  def monthly_days_of_month?
    monthly? && rules.is_a?(Array)
  end

  def monthly_days_of_week?
    monthly? && rules.is_a?(Hash)
  end

  def yearly_days_of_month?(month)
    yearly? && rules[month].is_a?(Array)
  end

  def yearly_days_of_week?(month)
    yearly? && rules[month].is_a?(Hash)
  end

  def duration_bound?
    starts_on?
  end

  def count_bound?
    count?
  end

  # TODO: #FutureScope occurrence between starts_on and (ends_on or count whichever comes first)
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
      if rules.values.first.is_a?(Hash)
        rules.each do |month_number, week_rules|
          week_rules.each do |day_of_week, week_numbers|
            week_numbers.each { |week_number| create_occurrence(day_of_week, weeks: week_number, months: month_number) }
          end
        end
      else
        rules.each do |month_number, days_of_month|
          days_of_month.each { |day_of_month| create_occurrence(day_of_month, months: month_number)}
        end
      end
    else
      # TODO: #FutureScope Add custom rule
      raise 'Invalid Rule. TODO: Support custom rule'
    end
  end

  def create_occurrence(days, weeks: nil, months: nil)
    o = occurrences.build
    o.recurrence_type = type
    o.interval = interval # TODO: Check interval and days logic
    o.days = days
    o.weeks = weeks
    o.months = months
    o.starts_on = starts_on
    o.ends_on = ends_on
    o.count = count
    o.save
  end

  def humanize
    msg = case type
    when 'Daily'
      interval == 1 ? 'Daily' : "Every #{interval} days"
    when 'Weekly'
      return 'Select day(s) of week' if rules.blank?
      s = interval == 1 ? 'Weekly' : "Every #{interval} weeks"
      s += " on #{day_names(rules.map(&:to_i))}"
    when 'Monthly'
      s = { 1 => 'Monthly', 3 => 'Quarterly', 6 => 'Half Yearly' }[interval] || "Every #{interval} months"
      if rules.is_a?(Array)
        return 'Select day(s) of month' if rules.blank?
        s += " on #{ordinalized_day_numbers(rules)} #{'day'.pluralize(rules.count)}"
      end
      if rules.is_a?(Hash)
        return 'Select day(s) of week' if rules.blank?
        s += " on #{weekly_rules_text(rules)}"
      end
      s += ' of the month'
    when 'Yearly'
      return 'Select criteria for year' if rules.blank?
      s = interval == 1 ? 'Yearly' : "Every #{interval} years"
      s += " on #{yearly_rules_text(rules)} of the year"
    else
      return 'Invalid Rule. TODO: Support custom rule'
    end
    msg += ' ' + ({ 1 => 'once', 2 => 'twice', 3 => 'thrice' }[count] || "#{count} times") if count_bound?
    if duration_bound?
      msg += " from #{starts_on} "
      msg += ends_on? ? "to #{ends_on}" : 'onwards'
    end
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
    array_rules_keys = []
    rules_hash.each { |key, value| array_rules_keys << key if value.is_a?(Array) }
    array_rules_hash = rules_hash.slice(*array_rules_keys)
    hash_rules_hash = rules_hash.except(*array_rules_keys)
    msg = if array_rules_hash.values.count > 1 && array_rules_hash.values.uniq.count == 1
        "#{array_rules_hash.values.first.to_ordinalized_collection_sentence} of #{month_names(array_rules_hash.keys.map(&:to_i))}"
      else
        array_rules_hash.map do |month_number, day_numbers|
          "#{day_numbers.to_ordinalized_collection_sentence(two_words_connector: ', ', last_word_connector: ', ')} #{Date::MONTHNAMES[month_number.to_i]}"
        end.to_sentence
      end
    msg += ' and ' if msg.present? && hash_rules_hash.present?
    msg += hash_rules_hash.map do |month_number, weekly_hash|
        "#{weekly_rules_text(weekly_hash)} of #{Date::MONTHNAMES[month_number.to_i]}"
      end.to_sentence
    msg
  end
end
