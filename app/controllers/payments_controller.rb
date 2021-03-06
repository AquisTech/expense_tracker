class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payments = current_scope.payments
  end

  def new
    @payment = current_user.payments.new
    render layout: false
  end

  def create
    @payment = current_user.payments.new(payment_params)
    if @payment.save
      redirect_to payments_path, notice: 'Payment was successfully created.'
    else
      render_failure(@payment)
    end
  end

  def update
    if @payment.update(payment_params)
      redirect_to payments_path, notice: 'Payment was successfully updated.'
    else
      render_failure(@payment)
    end
  end

  def destroy
    if @payment.destroy
      redirect_to payments_path, notice: 'Payment was successfully destroyed.'
    else
      redirect_to payments_path, notice: 'Payment could not be destroyed.'
    end
  end

  private
    def set_payment
      @payment = current_user.payments.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:amount, :payment_mode, :transaction_id, :account_id)
    end
end
