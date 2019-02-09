class AddReferenceTransactionPurposeToTransfers < ActiveRecord::Migration[5.2]
  def change
    add_reference :transfers, :transaction_purpose, index: true, foreign_key: true
  end
end
