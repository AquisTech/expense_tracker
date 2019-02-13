class Expense < ApplicationRecord
  belongs_to :user
  validates :starts_on, :ends_on, :credits, :debits, presence: true

  def recalculate_amount(start_date, end_date)
    self.credits = (start_date..end_date).map do |date|
      user.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(date).where(transaction_purposes: {credit: true}).sum(:estimate)
    end.sum
    self.debits = (start_date..end_date).map do |date|
      user.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(date).where(transaction_purposes: {credit: false}).sum(:estimate)
    end.sum
    self.save!
  end
end
