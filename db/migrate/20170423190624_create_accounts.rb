class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.string :details
      t.string :account_type
      t.text :payment_modes

      t.timestamps
    end
  end
end
