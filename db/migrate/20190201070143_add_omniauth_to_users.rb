class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string
    add_column :users, :expires_at, :integer
    add_column :users, :expires, :boolean
    add_column :users, :refresh_token, :string
    add_column :users, :image_url, :string
    add_column :users, :name, :string
    add_column :users, :locale, :string
    add_column :users, :gender, :string
    add_column :users, :currency, :string
  end
end
