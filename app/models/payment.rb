class Payment < ApplicationRecord

  PAYMENT_MODES = {
    OT: 'Online Transfer',
    DC: 'Debit Card',
    CC: 'Credit Card',
    EC: 'ECS',
    UP: 'UPI',
    EW: 'E-Wallet',
    CQ: 'Cheque',
    CS: 'Cash (Default)'
  }
  belongs_to :transactable, polymorphic: true
  belongs_to :account
  belongs_to :user

  # TODO: Add callback for converting amount to paise

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 } # TODO: Add gem to handle currency/money related stuff
  validates :payment_mode, presence: true, inclusion: { in: PAYMENT_MODES.keys.map(&:to_s) }
  validates :payment_mode, inclusion: {
                             in: proc { |p| p.account.payment_modes },
                             message: proc { |p| "is invalid for selected account. Supported payment modes are #{p.account.payment_modes.map { |pm| "'#{PAYMENT_MODES[pm.to_sym]}'" }.to_sentence }" }
                           }, if: proc { |p| p.account_id.present? }

  before_validation {
    self.user_id = self.transactable.user_id
    self.credit = self.transactable.credit if self.transactable.is_a?(Transaction)
  }
  after_create {
    puts "*****************update acc balance*******************"
    balance = self.account.account_balances.last.calculated_closing_balance
    self.account.account_balances.last.update_attribute(:calculated_closing_balance, balance.send(sign, amount))
  }
  # after_update {
  #   puts 'Revert from old acc and then update acc balance in new acc'
  # }

  def sign
    credit? ? '+' : '-'
  end
end
