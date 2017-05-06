class TransactionPurpose < ApplicationRecord
  belongs_to :sub_category
  has_one :recurrence_rule, dependent: :destroy
  has_many :transactions
end
