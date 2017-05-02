class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
    render layout: false
  end

  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      redirect_to transactions_url, notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_url, notice: 'Transaction was successfully updated.'
    else
      render :edit
    end
  end

  def show
    render layout: false
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:amount, :description, :transaction_purpose_id, :transfer_id)
    end
end
