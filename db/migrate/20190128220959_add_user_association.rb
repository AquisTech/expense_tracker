class AddUserAssociation < ActiveRecord::Migration[5.2]
  def change
    [:accounts, :account_balances, :transaction_purposes, :transactions, :transfers, :payments, :recurrence_rules, :occurrences].each do |table|
      add_reference table, :user, index: true
    end
  end
end
