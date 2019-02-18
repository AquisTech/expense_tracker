class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

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
