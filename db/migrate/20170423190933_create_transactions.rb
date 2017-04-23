class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :amount, default: 0
      t.string :description
      t.references :transaction_purpose, null: false, index: true
      t.references :transfer, index: true

      t.timestamps
    end
  end
end
