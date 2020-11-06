Rails.application.routes.draw do
  concern :with_datatable do
    post :datatable, on: :collection
  end
  resources :group_users
  resources :groups do
    post :invite_member, on: :collection
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users do
    collection do
      post :accept_membership
      post :decline_membership
      post :cancel_membership
      post :remove_from_group
      post :cancel_invitation
      post :block_membership
      post :block_user
      post :toggle_admin
      post :transfer_ownership
    end
  end
  get 'home/index'
  resources :occurrences
  resources :recurrence_rules
  resources :payments
  resources :accounts
  resources :transfers
  resources :transaction_purposes do
    get :display_recurrence_rule_text, on: :collection
  end
  resources :transactions
  resources :sub_categories
  resources :categories
  resources :account_balances
  resources :home
  resource :summary
  root to: 'home#index'
end