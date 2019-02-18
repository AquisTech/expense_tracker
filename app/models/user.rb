class User < ApplicationRecord
  # Include default devise modules. Others available are: :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :accounts
  has_many :account_balances
  has_many :transaction_purposes
  has_many :transactions
  has_many :transfers
  has_many :payments
  has_many :recurrence_rules
  has_many :occurrences
  has_many :expenses
  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :group_users
  has_many :groups, through: :group_users
  has_one :group_user
  has_one :family, -> { where(name: 'Family') }, through: :group_user, class_name: 'Group', source: :group

  after_create :add_default_cash_wallet!, :add_default_transaction_purposes!, :add_family!

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize
    user.name = auth.info.name unless user.name.present?
    user.password = SecureRandom.hex(6) unless user.encrypted_password.present?
    user.provider = auth.provider unless user.provider.present?
    user.uid = auth.uid unless user.uid.present?
    user.image_url = auth.info.image unless user.image_url.present?
    user.token = auth.credentials.token unless user.token.present?
    user.expires = auth.credentials.expires unless user.expires.present?
    user.expires_at = auth.credentials.expires_at unless user.expires_at.present?
    user.refresh_token = auth.credentials.refresh_token unless user.refresh_token.present?
    user.locale = auth.extra.raw_info.locale unless user.locale.present?
    user.gender = auth.extra.raw_info.gender unless user.gender.present?
    # user.currency = currency_for(auth.locale)
    user.skip_confirmation!
    user.save
    user
  end

  def add_default_transaction_purposes!
    self.transaction_purposes.new([
      {
        name: 'One Time Credit', sub_category: SubCategory.find_by(name: 'One Time Credit'), credit: true, estimate: 0,
        recurrence_rule_attributes: {type: 'Daily', interval: 1, starts_on: Time.now, user: self}
      },
      {
        name: 'One Time Debit', sub_category: SubCategory.find_by(name: 'One Time Debit'), credit: false, estimate: 0,
        recurrence_rule_attributes: {type: 'Daily', interval: 1, starts_on: Time.now, user: self}
      }
    ]).map(&:save!)
  end

  def add_default_cash_wallet!
    self.accounts.create!(name: 'Cash Wallet', description: 'Cash in hand', details: 'Cash in hand', account_type: 'CS', payment_modes: ['CS'])
  end

  def add_family!
    self.group_users.new(group: self.owned_groups.where(name: 'Family', default: true).first_or_create!, status: :accepted, admin: true).save!
  end

  def join_group(group) # accept_request
    self.group_users.find(group: group).accept!
  end
  alias_method :accept_request, :join_group

  def exit_group(group) # OR decline_request
    self.group_users.find(group: group).destroy
  end
  alias_method :decline_request, :exit_group

  def block_group(group)
    self.group_users.find(group: group).block!
  end

  def transfer_ownership(group) # TODO: move to group model
    group.update_attribute(:owner_id, self.id)
  end

  def toggle_admin(group)
    group_user = self.group_users.find(group: group)
    group_user.update_attribute(:admin, !group_user.admin?)
  end

  def self.search(term)
    User.find_by('email = :term', term: term)
  end

  def group_admin_for?(group)
    self.group_users.find_by(group_id: group.id).admin?
  end
end
