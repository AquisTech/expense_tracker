class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_users
  has_many :users, through: :group_users
  validates :name, presence: true


  def invite(member) # send_request
    self.group_users.where(user: member, status: :invited).first_or_create!
  end

  def request(member) # request to join
    self.group_users.where(user: member, status: :requested).first_or_create!
  end
end
