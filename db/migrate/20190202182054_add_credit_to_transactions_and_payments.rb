class AddCreditToTransactionsAndPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :credit, :boolean, default: false
    add_column :payments, :credit, :boolean, default: false
  end
end
