class CreateAccountBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :account_balances do |t|
      t.integer :opening_balance, default: 0
      t.integer :calculated_closing_balance, default: 0
      t.integer :actual_closing_balance, default: 0
      t.integer :month, null: false
      t.integer :year, null: false
      t.references :account, null: false, index: true

      t.timestamps
    end
  end
end
