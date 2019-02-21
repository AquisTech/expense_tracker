class AddPreferredPaymentModeAndPreferredAccountToTransactionPurposes < ActiveRecord::Migration[5.2]
  def change
    add_column :transaction_purposes, :preferred_payment_mode, :string
    add_reference :transaction_purposes, :preferred_account, index: true
  end
end
