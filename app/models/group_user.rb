class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :accounts, primary_key: :user_id, foreign_key: :user_id
  has_many :transaction_purposes, primary_key: :user_id, foreign_key: :user_id
  has_many :transactions, primary_key: :user_id, foreign_key: :user_id
  has_many :transfers, primary_key: :user_id, foreign_key: :user_id
  has_many :payments, primary_key: :user_id, foreign_key: :user_id
  has_many :occurrences, primary_key: :user_id, foreign_key: :user_id
  # has_many :expenses, primary_key: :user_id, foreign_key: :user_id

  enum status: { requested: 0, invited: 1, accepted: 2, blocked: 3 } do
    event :accept do
      transition [:requested, :invited] => :accepted

      # after do
      #   friendable.on_friendship_accepted(self)
      # end
    end

    event :block do
      # before do
      #   self.blocker_id = self.friendable.id
      # end

      # after do
      #   friendable.on_friendship_blocked(self)
      # end
      transition all - [:blocked] => :blocked
    end
  end
end
