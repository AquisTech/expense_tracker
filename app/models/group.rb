class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_users
  has_many :users, through: :group_users
  has_many :accounts, through: :group_users
  has_many :transaction_purposes, through: :group_users
  has_many :transactions, through: :group_users
  has_many :transfers, through: :group_users
  has_many :payments, through: :group_users
  has_many :occurrences, through: :group_users
  # has_many :expenses, through: :group_users # TODO: Make expenses polymorphic
  validates :name, presence: true

  def invite(member) # send_request
    self.group_users.where(user: member, status: :invited).first_or_create!
  end

  def request(member) # request to join
    self.group_users.where(user: member, status: :requested).first_or_create!
  end
end
