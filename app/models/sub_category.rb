class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transaction_purposes

  validates :name, presence: true

  def name_with_category
    "#{category.name}: #{name}"
  end
end
