class AddTransferToTransactionPurposes < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_purposes, :transfer, :boolean, default: false
  end
end
