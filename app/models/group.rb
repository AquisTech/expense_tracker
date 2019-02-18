class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_users
  has_many :users, through: :group_users
  validates :name, presence: true


  def invite(member) # send_request
    self.group_users.new(user: member, status: :invited).save!
  end
end
