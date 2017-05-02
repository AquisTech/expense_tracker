class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

  def index
    @transfers = Transfer.all
  end

  def new
    @transfer = Transfer.new
    render layout: false
  end

  def create
    @transfer = Transfer.new(transfer_params)
    if @transfer.save
      redirect_to transfers_url, notice: 'Transfer was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @transfer.update(transfer_params)
      redirect_to transfers_url, notice: 'Transfer was successfully updated.'
    else
      render :edit
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
      @transfer = Transfer.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:amount, :description, :source_account_id, :destination_account_id)
    end
end
