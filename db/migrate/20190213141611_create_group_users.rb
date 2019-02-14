class CreateGroupUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_users do |t|
      t.references :user, null: false, index: true
      t.references :group, null: false, index: true
    end
  end
end
