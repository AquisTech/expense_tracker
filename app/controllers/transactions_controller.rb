class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @transactions = pagy(current_scope.transactions)
  end

  def new
    @transaction = current_user.transactions.new
    render layout: false
  end

  # TODO: Make this compatible for transcations/form
  # This action is called from home/index
  def create
    transaction = current_user.transactions.new(transaction_params)
    if transaction.save
      new_transaction = current_user.transactions.new
      new_transaction.payments.build
      flash[:success] = 'Transaction created successfully.'
      render :success, locals: { transaction: transaction, new_transaction: new_transaction, transacted_at: params[:transaction][:transacted_at] }
    else
      flash[:failure] = transaction.errors.full_messages.to_sentence
      render :failure, locals: { transaction: transaction } # TODO: Check n Remove locals
    end
  end

  # TODO: Make this compatible for transcations/form
  # This action is called from home/index
  def update
    if @transaction.update(transaction_params)
      flash[:success] = 'Transaction updated successfully.'
      render :success, locals: { transaction: @transaction, transacted_at: params[:transaction][:transacted_at] }
    else
      flash[:failure] = @transaction.errors.full_messages.to_sentence
      render :failure, locals: { transaction: @transaction }
    end
  end

  def destroy
    if @transaction.destroy
      redirect_to transactions_path, success: 'Transaction destroyed successfully.'
    else
      redirect_to transactions_path, failure: 'Transaction could not be destroyed.'
    end
  end

  private
    def set_transaction
      @transaction = current_user.transactions.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:amount, :description, :transaction_purpose_id, :transfer_id, :transacted_at, payments_attributes: {})
    end
end
