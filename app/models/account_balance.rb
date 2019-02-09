class AccountBalance < ApplicationRecord
  belongs_to :account
  belongs_to :user

  # TODO: Add callback for converting amount to paise
  # TODO: Add gem to handle currency/money related stuff
  validates :opening_balance, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :calculated_closing_balance, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :actual_closing_balance, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation {
    self.user_id = self.account.user_id
    self.actual_closing_balance = 0 unless self.actual_closing_balance
  }
  before_create {
    self.calculated_closing_balance = self.opening_balance
  }
end
