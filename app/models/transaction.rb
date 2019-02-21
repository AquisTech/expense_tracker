class Transaction < ApplicationRecord

  belongs_to :transaction_purpose # TODO: Prevent destroy of transaction purpose if transactions are associated. Use soft delete
  belongs_to :user

  has_many :payments, as: :transactable, dependent: :destroy # TODO: Check if destroy is correct or we have to use nullify to maintain history

  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: :all_blank

  # TODO: Add callback for converting amount to paise

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0, equal_to: proc { |t| t.total_payments_amount } } # TODO: Add gem to handle currency/money related stuff
  validates :description, presence: true

  before_validation { self.credit = self.transaction_purpose.credit }

  def total_payments_amount # TODO: Change error message as 'Sum of payments must be equal to transaction amount.'
    payments.sum(&:amount)
  end

  def sign
    credit? ? '+' : '-'
  end
  # TODO: Add tags to transactions
end
