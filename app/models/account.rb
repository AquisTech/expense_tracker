class Account < ApplicationRecord

  serialize :payment_modes

  has_many :account_balances
  has_many :transactions
  has_many :transfers

  ACCOUNT_TYPES = {
    SB: 'Saving Bank Account',
    CB: 'Current Bank Account',
    CC: 'Credit Card',
    SC: 'Smart Card',
    EW: 'E-Wallet',
    CS: 'Cash'
  }

  validates :name, presence: true
  validates :description, presence: true
  validates :details, presence: true
  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES.keys.map(&:to_s) }
  validates :payment_modes, presence: true, inclusion: { in: Payment::PAYMENT_MODES.keys.map(&:to_s) }

  def account_type_name
    ACCOUNT_TYPES[account_type.to_sym]
  end
end
