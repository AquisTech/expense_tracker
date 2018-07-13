class Transaction < ApplicationRecord

  belongs_to :transaction_purpose
  # belongs_to :transfer # TODO: Make transfer association nullable

  has_many :payments, dependent: :destroy, inverse_of: :transaxion # TODO: Check if destroy is correct or we have to use nullify to maintain history

  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: :all_blank

  # TODO: Add callback for converting amount to paise

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0, equal_to: proc { |t| t.total_payments_amount } } # TODO: Add gem to handle currency/money related stuff
  validates :description, presence: true

  def total_payments_amount
    payments.sum(&:amount)
  end
  # TODO: Add tags to transactions
end
