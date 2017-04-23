class CreateTransactionPurposes < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_purposes do |t|
      t.string :name
      t.references :sub_category, null: false, index: true

      t.timestamps
    end
  end
end
