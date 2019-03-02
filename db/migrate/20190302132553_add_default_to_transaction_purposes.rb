class AddDefaultToTransactionPurposes < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_purposes, :default, :boolean, default: false
  end
end
