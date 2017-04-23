class Transfer < ApplicationRecord
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
  has_one :credit_transaction, class_name: 'Transaction' # TODO: Add condition
  has_one :debit_transaction, class_name: 'Transaction' # TODO: Add condition
end
