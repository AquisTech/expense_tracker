class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

  def index
    @transfers = current_user.transfers
  end

  def new
    @transfer = current_user.transfers.new
    render layout: false
  end

  def create
    @transfer = current_user.transfers.new(transfer_params)
    if @transfer.save
      redirect_to transfers_url, notice: 'Transfer was successfully created.'
    else
      render_failure(@transfer)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @transfer.update(transfer_params)
      redirect_to transfers_url, notice: 'Transfer was successfully updated.'
    else
      render_failure(@transfer)
    end
  end

  def show
    render layout: false
  end

  def destroy
    @transfer.destroy
    redirect_to transfers_url, notice: 'Transfer was successfully destroyed.'
  end

  private
    def set_transfer
      @transfer = current_user.transfers.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:amount, :description, :source_account_id, :destination_account_id)
    end
end
