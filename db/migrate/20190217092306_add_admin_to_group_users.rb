class AddAdminToGroupUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_users, :admin, :boolean, default: false
  end
end
