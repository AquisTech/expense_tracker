class User < ApplicationRecord
  # Include default devise modules. Others available are: :timeoutable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
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
  has_many :expenses, as: :owner
  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :group_users
  has_many :groups, through: :group_users
  has_one :group_user
  has_one :family, -> { where(default: true, group_users: { status: :accepted }) }, through: :group_user, class_name: 'Group', source: :group

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
    time = Time.now
    self.transaction_purposes.new([
      {
        name: 'Unscheduled Credit', sub_category: SubCategory.find_by(name: 'Unscheduled Credit'), credit: true, estimate: 0, default: true,
        recurrence_rule_attributes: {type: 'Daily', interval: 1, starts_on: time, ends_on: time + 1.second, user: self, count: 0}
      },
      {
        name: 'Unscheduled Debit', sub_category: SubCategory.find_by(name: 'Unscheduled Debit'), credit: false, estimate: 0, default: true,
        recurrence_rule_attributes: {type: 'Daily', interval: 1, starts_on: time, ends_on: time + 1.second, user: self, count: 0}
      }
    ]).map(&:save!)
  end

  def add_default_cash_wallet!
    self.accounts.create!(
      name: 'Cash Wallet', description: 'Cash in hand', details: 'Cash in hand', account_type: 'CS', payment_modes: [], default: true,
      account_balances_attributes: [{ opening_balance: 0, calculated_closing_balance: 0, actual_closing_balance: 0, month: DateTime.now.month, year: DateTime.now.year, user: self }]
    )
  end

  def add_family!
    self.group_users.where(group: self.owned_groups.where(name: 'Family', default: true).first_or_create!, status: :accepted, admin: true).first_or_create!
  end

  def remove_family!
    self.group_users.find_by(group_id: self.family.id).destroy! && self.family.destroy!
  end

  def join_group(group) # accept_request
    remove_family! if group.default? && self.family && self.family.owner == self
    self.group_users.find_by(group_id: group.id).accept!
  end

  def exit_group(group)
    if group_owner_for?(group)
      self.errors.add(:base, 'Please transfer ownership before exiting group.')
      false
    else
      self.group_users.find_by(group_id: group.id).destroy
      add_family! if group.default? && self.family.nil?
    end
  end

  def decline_request(group)
    self.group_users.find_by(group_id: group.id).destroy
  end

  def block_group(group)
    self.group_users.find_by(group_id: group.id).block!
  end

  def transfer_ownership(group) # TODO: move to group model
    group.update_attribute(:owner_id, self.id) && self.make_admin
  end

  def make_admin(group)
    group_user = self.group_users.find_by(group_id: group.id)
    group_user.update_attribute(:admin, true)
  end

  def toggle_admin(group)
    group_user = self.group_users.find_by(group_id: group.id)
    group_user.update_attribute(:admin, !group_user.admin?)
  end

  def self.search(term)
    User.find_by('email = :term', term: term)
  end

  def group_admin_for?(group)
    self.group_users.find_by(group_id: group.id).admin?
  end

  def group_owner_for?(group)
    self == group.owner
  end
end
