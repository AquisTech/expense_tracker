class Account < ApplicationRecord
  has_many :account_balances
  has_many :transactions
  has_many :transfers

  ACCOUNT_TYPES = {
    SB: 'Saving Bank Account',
    CB: 'Current Bank Account',
    CC: 'Credit Card',
    EW: 'E-Wallet',
    CS: 'Cash'
  }
end
