class Account < ApplicationRecord

  serialize :payment_modes

  belongs_to :user
  has_many :account_balances, dependent: :destroy
  has_many :transactions, dependent: :restrict_with_error
  has_many :transfers, dependent: :restrict_with_error
  accepts_nested_attributes_for :account_balances, allow_destroy: true, reject_if: :all_blank

  ACCOUNT_TYPES = {
    SB: 'Saving Bank Account',
    CB: 'Current Bank Account',
    CC: 'Credit Card',
    SC: 'Smart Card',
    EW: 'E-Wallet',
    CS: 'Cash'
  }
  before_validation {
    self.payment_modes << 'CS'
  }
  validates :name, presence: true
  validates :description, presence: true
  validates :details, presence: true
  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES.keys.map(&:to_s) }
  validates :payment_modes, presence: true #, inclusion: { in: Payment::PAYMENT_MODES.keys.map(&:to_s) } TODO: Validate serialized attributes

  def account_type_name
    ACCOUNT_TYPES[account_type.to_sym]
  end
end
