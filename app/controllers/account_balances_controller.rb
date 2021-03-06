class AccountBalancesController < ApplicationController
  before_action :set_account_balance, only: [:show, :edit, :update, :destroy]

  def index
    @account_balances = current_user.account_balances
  end

  def new
    @account_balance = current_user.account_balances.new
    render layout: false
  end

  def create
    @account_balance = current_user.account_balances.new(account_balance_params)
    if @account_balance.save
      redirect_to account_balances_path, notice: 'Account balance was successfully created.'
    else
      render_failure(@account_balance)
    end
  end

  def update
    if @account_balance.update(account_balance_params)
      redirect_to account_balances_path, notice: 'Account balance was successfully updated.'
    else
      render_failure(@account_balance)
    end
  end

  def destroy
    if @account_balance.destroy
      redirect_to account_balances_path, notice: 'Account balance was successfully destroyed.'
    else
      redirect_to account_balances_path, notice: 'Account balance could not be destroyed.'
    end
  end

  private
    def set_account_balance
      @account_balance = current_user.account_balances.find(params[:id])
    end

    def account_balance_params
      params.require(:account_balance).permit(:opening_balance, :calculated_closing_balance, :actual_closing_balance, :month, :year, :account_id)
    end
end
