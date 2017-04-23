class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transaction_purposes
end
