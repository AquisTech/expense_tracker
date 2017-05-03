class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payments = Payment.all
  end

  def new
    @payment = Payment.new
    render layout: false
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to payments_url, notice: 'Payment was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @payment.update(payment_params)
      redirect_to payments_url, notice: 'Payment was successfully updated.'
    else
      render :edit
    end
  end

  def show
    render layout: false
  end

  def destroy
    @payment.destroy
    redirect_to payments_url, notice: 'Payment was successfully destroyed.'
  end

  private
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:amount, :payment_mode, :transaction_id, :account_id)
    end
end
