Rails.application.routes.draw do
  resources :recurrence_rules
  resources :payments
  resources :accounts
  resources :transfers
  resources :transaction_purposes
  resources :transactions
  resources :sub_categories
  resources :categories
  resources :account_balances
end
