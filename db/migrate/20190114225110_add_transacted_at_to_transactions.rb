class AddTransactedAtToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :transacted_at, :datetime, null: false
  end
end
