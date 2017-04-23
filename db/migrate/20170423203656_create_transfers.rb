class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.integer :amount, default: 0
      t.string :description
      t.references :source_account, null: false, index: true
      t.references :destination_account, null: false, index: true

      t.timestamps
    end
  end
end
