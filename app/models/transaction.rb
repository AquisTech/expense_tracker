class Transaction < ApplicationRecord

  belongs_to :transaction_purpose
  # belongs_to :transfer # TODO: Make transfer association nullable

  has_many :payments, dependent: :destroy, inverse_of: :transaxion # TODO: Check if destroy is correct or we have to use nullify to maintain history

  accepts_nested_attributes_for :payments

  # TODO: Add callback for converting amount to paise

  validates :amount, presence: true # TODO: Add gem to handle currency/money related stuff
end
