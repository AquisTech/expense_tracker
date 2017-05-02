class PaymentSourcesController < ApplicationController
  before_action :set_payment_source, only: [:show, :edit, :update, :destroy]

  def index
    @payment_sources = PaymentSource.all
  end

  def new
    @payment_source = PaymentSource.new
    render layout: false
  end

  def create
    @payment_source = PaymentSource.new(payment_source_params)
    if @payment_source.save
      redirect_to payment_sources_url, notice: 'Payment source was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @payment_source.update(payment_source_params)
      redirect_to payment_sources_url, notice: 'Payment source was successfully updated.'
    else
      render :edit
    end
  end

  def show
    render layout: false
  end

  def destroy
    @payment_source.destroy
    redirect_to payment_sources_url, notice: 'Payment source was successfully destroyed.'
  end

  private
    def set_payment_source
      @payment_source = PaymentSource.find(params[:id])
    end

    def payment_source_params
      params.require(:payment_source).permit(:amount, :payment_mode, :transaction_id, :account_id)
    end
end
