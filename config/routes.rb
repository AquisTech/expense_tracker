Rails.application.routes.draw do
  resources :transfers
  resources :transaction_purposes
  resources :transactions
  resources :sub_categories
  resources :categories
  resources :account_balances
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
