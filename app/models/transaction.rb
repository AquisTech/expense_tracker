class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :transaction_purpose
  belongs_to :transfer

  # TODO: Add callback for converting amount to paise
end
