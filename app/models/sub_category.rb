class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transaction_purposes

  def name_with_category
    "#{category.name}: #{name}"
  end
end
