class AccountBalancesController < ApplicationController
  before_action :set_account_balance, only: [:show, :edit, :update, :destroy]

  def index
    @account_balances = AccountBalance.all
  end

  def new
    @account_balance = AccountBalance.new
    render layout: false
  end

  def create
    @account_balance = AccountBalance.new(account_balance_params)
    if @account_balance.save
      redirect_to account_balances_url, notice: 'Account balance was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @account_balance.update(account_balance_params)
      redirect_to account_balances_url, notice: 'Account balance was successfully updated.'
    else
      render :edit
    end
  end

  def show
    render layout: false
  end

  def destroy
    @account_balance.destroy
    redirect_to account_balances_url, notice: 'Account balance was successfully destroyed.'
  end

  private
    def set_account_balance
      @account_balance = AccountBalance.find(params[:id])
    end

    def account_balance_params
      params.require(:account_balance).permit(:opening_balance, :calculated_closing_balance, :actual_closing_balance, :month, :year, :account_id)
    end
end
