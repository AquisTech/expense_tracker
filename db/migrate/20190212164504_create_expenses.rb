class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    drop_table :expenses
    create_table :expenses do |t|
      t.datetime :starts_on
      t.datetime :ends_on
      t.integer :credits, default: 0
      t.integer :debits, default: 0
      t.references :user, null:false, index: true
      t.timestamps
    end
  end
end
