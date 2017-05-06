class CreateOccurrences < ActiveRecord::Migration[5.2]
  def change
    create_table :occurrences do |t|
      t.string :recurrence_type
      t.integer :interval
      t.integer :days
      t.integer :weeks
      t.integer :months
      t.datetime :starts_on
      t.datetime :ends_on
      t.integer :count
      t.belongs_to :recurrence_rule, foreign_key: true

      t.timestamps
    end
  end
end
