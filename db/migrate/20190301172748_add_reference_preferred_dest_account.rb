class AddReferencePreferredDestAccount < ActiveRecord::Migration[5.2]
  def change
    add_reference :transaction_purposes, :preferred_dest_account, index: true
  end
end
