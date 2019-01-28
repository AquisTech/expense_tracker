Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  resources :occurrences
  resources :recurrence_rules
  resources :payments
  resources :accounts
  resources :transfers
  resources :transaction_purposes do
    get :display_recurrence_rule_text, on: :collection
    get :get_estimate, on: :member
  end
  resources :transactions
  resources :sub_categories
  resources :categories
  resources :account_balances
  resources :home
  resource :summary
  root to: 'home#index'
end