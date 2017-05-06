class CreateRecurrenceRules < ActiveRecord::Migration[5.2]
  def change
    create_table :recurrence_rules do |t|
      t.string :type
      t.integer :interval
      t.datetime :starts_on
      t.datetime :ends_on
      t.integer :count
      t.text :rules
      t.belongs_to :transaction_purpose, foreign_key: true

      t.timestamps
    end
  end
end
