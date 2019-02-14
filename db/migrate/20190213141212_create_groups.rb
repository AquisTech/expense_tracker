class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.boolean :default, default: false
      t.timestamps
    end
  end
end
