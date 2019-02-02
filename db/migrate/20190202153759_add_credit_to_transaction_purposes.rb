class AddCreditToTransactionPurposes < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_purposes, :credit, :boolean, default: false
  end
end
