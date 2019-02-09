class ChangeReferenceTransactionToTransactableInPayments < ActiveRecord::Migration[5.2]
  def change
    rename_column :payments, :transaction_id, :transactable_id
    add_column :payments, :transactable_type, :string
  end
end
