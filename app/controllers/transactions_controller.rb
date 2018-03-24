class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
    render layout: false
  end

  # TODO: Make this compatible for transcations/form
  # This action is called from home/index
  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      render :success, locals: {tp_id: @transaction.transaction_purpose_id}
    else
      render :failure, locals: {transaction: @transaction}
    end
  end

  def edit
    render layout: false
  end

  # TODO: Make this compatible for transcations/form
  # This action is called from home/index
  def update
    if @transaction.update(transaction_params)
      render :success, locals: {tp_id: @transaction.transaction_purpose_id}
    else
      render :failure, locals: {transaction: @transaction}
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
      params.require(:transaction).permit(:amount, :description, :transaction_purpose_id, :transfer_id, payments_attributes: {})
    end
end
