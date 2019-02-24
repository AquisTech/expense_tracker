class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :transaction_purposes, dependent: :restrict_with_error

  validates :name, presence: true

  def name_with_category
    "#{category.name}: #{name}"
  end
end
