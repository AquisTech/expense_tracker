class AddTransactedAtToTransfers < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :transacted_at, :datetime, null: false
  end
end
