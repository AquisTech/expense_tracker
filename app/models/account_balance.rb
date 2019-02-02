class AccountBalance < ApplicationRecord
  belongs_to :account
  belongs_to :user

  # TODO: Add callback for converting amount to paise
  # TODO: Add gem to handle currency/money related stuff
  validates :opening_balance, presence: true, numericality: { only_integer: true }
  validates :calculated_closing_balance, presence: true, numericality: { only_integer: true }
  validates :actual_closing_balance, presence: true, numericality: { only_integer: true }
  before_create {
    self.calculated_closing_balance = self.opening_balance
  }
end
