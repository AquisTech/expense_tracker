class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
    render layout: false
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to accounts_url, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_url, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def show
    render layout: false
  end

  def destroy
    @account.destroy
    redirect_to accounts_url, notice: 'Account was successfully destroyed.'
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :description, :details, :account_type)
    end
end
