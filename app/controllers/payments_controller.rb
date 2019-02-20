class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payments = (family_view? ? current_user.family : current_user).payments
  end

  def new
    @payment = current_user.payments.new
    render layout: false
  end

  def create
    @payment = current_user.payments.new(payment_params)
    if @payment.save
      redirect_to payments_url, notice: 'Payment was successfully created.'
    else
      render_failure(@payment)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @payment.update(payment_params)
      redirect_to payments_url, notice: 'Payment was successfully updated.'
    else
      render_failure(@payment)
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
      @payment = current_user.payments.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:amount, :payment_mode, :transaction_id, :account_id)
    end
end
