class TransactionPurpose < ApplicationRecord
  belongs_to :sub_category
  has_one :recurrence_rule, dependent: :destroy
  has_many :transactions

  accepts_nested_attributes_for :recurrence_rule

  def humanize
    recurrence_rule.humanize
  end
end
