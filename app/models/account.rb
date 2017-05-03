class Account < ApplicationRecord
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

  # getter method
  def account_type
    ACCOUNT_TYPES[self[:account_type].to_sym]
  end

  def account_type_code
    self[:account_type]
  end
end
