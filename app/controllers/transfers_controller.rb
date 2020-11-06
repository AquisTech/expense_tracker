class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

  def index
    @transfers = current_scope.transfers
  end

  def new
    @transfer = current_user.transfers.new
    render layout: false
  end

  # TODO: Make this compatible for transfers/form
  # This action is called from home/index
  def create
    transfer = current_user.transfers.new(transfer_params)
    if transfer.save
      new_transaction = current_user.transfers.new
      new_transaction.payments.build
      flash[:success] = 'Transfer created successfully.'
      render :success, locals: { transaction: transfer, new_transaction: new_transaction, transacted_at: params[:transfer][:transacted_at] }
    else
      flash[:failure] = transfer.errors.full_messages.to_sentence
      render :failure, locals: { transaction: transfer } # TODO: Check n Remove locals
    end
  end

  # TODO: Make this compatible for transfers/form
  # This action is called from home/index
  def update
    if @transfer.update(transfer_params)
      flash[:success] = 'Transfer updated successfully.'
      render :success, locals: { transaction: @transfer, transacted_at: params[:transfer][:transacted_at] }
    else
      flash[:failure] = @transfer.errors.full_messages.to_sentence
      render :failure, locals: { transaction: @transfer }
    end
  end

  def destroy
    if @transfer.destroy
      redirect_to transfers_path, notice: 'Transfer was successfully destroyed.'
    else
      redirect_to transfers_path, notice: 'Transfer could not be destroyed.'
    end
  end

  private
    def set_transfer
      @transfer = current_user.transfers.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:amount, :description, :payment_mode, :transacted_at, :transaction_purpose_id, :source_account_id, :destination_account_id)
    end
end
