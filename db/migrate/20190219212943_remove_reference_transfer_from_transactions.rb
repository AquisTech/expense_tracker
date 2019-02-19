class RemoveReferenceTransferFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_reference :transactions, :transfer, index: true
  end
end
