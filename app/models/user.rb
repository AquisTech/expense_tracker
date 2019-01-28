class User < ApplicationRecord
  # Include default devise modules. Others available are: :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :accounts
  has_many :account_balances
  has_many :transaction_purposes
  has_many :transactions
  has_many :transfers
  has_many :payments
  has_many :recurrence_rules
  has_many :occurrences

end
