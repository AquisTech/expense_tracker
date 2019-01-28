class AccountBalance < ApplicationRecord
  belongs_to :account
  belongs_to :user

  # TODO: Add callback for converting amount to paise
  # TODO: Add gem to handle currency/money related stuff
  validates :opening_balance, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :calculated_closing_balance, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :actual_closing_balance, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
