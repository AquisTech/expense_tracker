class CreatePaymentSources < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_sources do |t|
      t.integer :amount, default: 0
      t.string :payment_mode
      t.references :transaction, null: false, index: true
      t.references :account, null: false, index: true

      t.timestamps
    end
  end
end
