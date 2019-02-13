class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.datetime :starts_on
      t.datetime :ends_on
      t.integer :amount, default: 0
      t.references :user, null:false, index: true
      t.timestamps
    end
  end
end
