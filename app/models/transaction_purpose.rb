class TransactionPurpose < ApplicationRecord
  belongs_to :sub_category
  has_many :transactions
end
