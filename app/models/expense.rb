class Expense < ApplicationRecord
  belongs_to :user
  validates :starts_on, :ends_on, :amount, presence: true

  def recalculate_amount(start_date, end_date)
    self.amount = (start_date..end_date).map do |date|
      user.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(date).sum(:estimate)
    end.sum
    self.save!
    amount
  end
end
