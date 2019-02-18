class AddReferenceOwnerToGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :groups, :owner, index: true
  end
end
