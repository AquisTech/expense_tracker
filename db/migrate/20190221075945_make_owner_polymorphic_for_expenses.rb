class MakeOwnerPolymorphicForExpenses < ActiveRecord::Migration[5.2]
  def change
    remove_reference :expenses, :user, null: false, index: true
    add_reference :expenses, :owner, polymorphic: true, index: true
  end
end
