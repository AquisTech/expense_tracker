class Transfer < ApplicationRecord
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
  has_one :credit_transaction, class_name: 'Transaction' # TODO: Add condition
  has_one :debit_transaction, class_name: 'Transaction' # TODO: Add condition

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 } # TODO: Add gem to handle currency/money related stuff
  validates :source_account_id, numericality: { other_than: proc {|t| t.destination_account_id}, message: 'cannot be same as Destination Account' },
            if: proc {|t| t.source_account_id && t.destination_account_id }
end
