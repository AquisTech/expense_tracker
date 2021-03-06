class TransactionPurpose < ApplicationRecord
  belongs_to :sub_category
  belongs_to :user
  belongs_to :preferred_account, class_name: 'Account', optional: true
  belongs_to :preferred_dest_account, class_name: 'Account', optional: true
  has_one :recurrence_rule, dependent: :destroy
  has_many :transactions, dependent: :restrict_with_error
  has_many :transfers, dependent: :restrict_with_error
  has_many :occurrences, through: :recurrence_rule

  accepts_nested_attributes_for :recurrence_rule

  validates :name, presence: true
  # TODO: Add callback for converting estimate to paise
  # TODO: Add gem to handle currency/money related stuff
  validates :estimate, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def humanize # TODO: Use deligate
    recurrence_rule.humanize
  end

  def sign_class
    credit? ? 'plus' : 'minus'
  end

  def sign
    credit? ? '+' : '-'
  end
end
