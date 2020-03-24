class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @accounts = pagy(current_scope.accounts)
  end

  def new
    @account = current_user.accounts.new
    @account.account_balances.build
    render layout: false
  end

  def create
    @account = current_user.accounts.new(account_params)
    if @account.save
      redirect_to accounts_path, notice: 'Account was successfully created.'
    else
      render_failure(@account)
    end
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: 'Account was successfully updated.'
    else
      render_failure(@account)
    end
  end

  def destroy
    if @account.destroy
      redirect_to accounts_path, notice: 'Account was successfully destroyed.'
    else
      redirect_to accounts_path, notice: 'Account could not be destroyed.'
    end
  end

  private
    def set_account
      @account = current_user.accounts.find(params[:id])
    end

    def account_params
      params[:account][:payment_modes] = params[:account][:payment_modes].without('')
      params.require(:account).permit(:name, :description, :details, :account_type, payment_modes: [], account_balances_attributes: {})
    end
end
