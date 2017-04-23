class CreateSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.references :category, null:false, index: true

      t.timestamps
    end
  end
end
