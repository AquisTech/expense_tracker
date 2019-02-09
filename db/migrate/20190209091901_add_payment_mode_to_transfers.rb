class AddPaymentModeToTransfers < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :payment_mode, :string
  end
end
