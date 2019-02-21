class Transfer < ApplicationRecord
  belongs_to :user
  belongs_to :transaction_purpose
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
  has_many :payments, as: :transactable, dependent: :destroy
  has_one :credit_payment, -> { where(credit: true) }, class_name: 'Payment', foreign_key: :transactable_id
  has_one :debit_payment, -> { where(credit: false) }, class_name: 'Payment', foreign_key: :transactable_id

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 } # TODO: Add gem to handle currency/money related stuff
  validates :source_account_id, numericality: { other_than: proc {|t| t.destination_account_id}, message: 'cannot be same as Destination Account' },
            if: proc {|t| t.source_account_id && t.destination_account_id }
  validates :description, presence: true
  validates :payment_mode, presence: true

  after_save :manage_payments

  def manage_payments
    puts "-------------add debit-------------------------------------------------"
    debit = self.payments.where(credit: false).first_or_initialize
    debit.amount = amount; debit.payment_mode = payment_mode; debit.account = source_account; debit.user = user
    debit.save!
    puts "-------------add credit-------------------------------------------------"
    credit = self.payments.where(credit: true).first_or_initialize
    credit.amount = amount; credit.payment_mode = payment_mode; credit.account = destination_account; credit.user = user
    credit.save!
  end
end
