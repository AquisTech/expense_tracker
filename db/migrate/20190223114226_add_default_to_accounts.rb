class AddDefaultToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :default, :boolean, default: false
  end
end
