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
    transaction = Transaction.new(transaction_params)
    if transaction.save
      new_transaction = Transaction.new
      new_transaction.payments.build
      flash[:success] = 'Transaction created successfully.'
      render :success, locals: { transaction: transaction, new_transaction: new_transaction }
    else
      flash[:failure] = transaction.errors.full_messages.to_sentence
      render :failure, locals: { transaction: transaction }
    end
  end

  def edit
    render layout: false
  end

  # TODO: Make this compatible for transcations/form
  # This action is called from home/index
  def update
    if @transaction.update(transaction_params)
      flash[:success] = 'Transaction updated successfully.'
      render :success, locals: { transaction: @transaction }
    else
      flash[:failure] = @transaction.errors.full_messages.to_sentence
      render :failure, locals: { transaction: @transaction }
    end
  end

  def show
    render layout: false
  end

  def destroy
    if @transaction.destroy
      redirect_to transactions_url, success: 'Transaction destroyed successfully.'
    else
      redirect_to transactions_url, failure: 'Transaction failed to destroy.'
    end
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:amount, :description, :transaction_purpose_id, :transfer_id, payments_attributes: {})
    end
end
