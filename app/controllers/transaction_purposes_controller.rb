class TransactionPurposesController < ApplicationController
  before_action :set_transaction_purpose, only: [:show, :edit, :update, :destroy]

  def index
    @transaction_purposes = current_user.transaction_purposes
  end

  def new
    @transaction_purpose = current_user.transaction_purposes.new
    @transaction_purpose.build_recurrence_rule(type: 'Daily', interval: 1)
    render layout: false
  end

  def create
    @transaction_purpose = current_user.transaction_purposes.new(transaction_purpose_params)
    @transaction_purpose.recurrence_rule.user_id = current_user.id
    if @transaction_purpose.save
      redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully created.'
    else
      render_failure(@transaction_purpose)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @transaction_purpose.update(transaction_purpose_params)
      redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully updated.'
    else
      render_failure(@transaction_purpose)
    end
  end

  def show
    render layout: false
  end

  def destroy
    @transaction_purpose.destroy
    redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully destroyed.'
  end

  def display_recurrence_rule_text
    tp_params = transaction_purpose_params
    tp_params[:recurrence_rule_attributes].delete(:id)
    tp = TransactionPurpose.new(tp_params)
    begin
      msg = tp.humanize
    rescue Exception => e
      msg = "#{e.message} | #{e.backtrace}"
    end
    render json: { msg: msg }, status: :ok
  end

  def get_estimate
    tp = current_user.transaction_purposes.find(params[:id])
    render json: tp.estimate, status: :ok
  end

  private
    def set_transaction_purpose
      @transaction_purpose = current_user.transaction_purposes.find(params[:id])
    end

    def transaction_purpose_params
      rules = params[:transaction_purpose][:recurrence_rule_attributes][:rules]
      type = params[:transaction_purpose][:recurrence_rule_attributes][:type]
      rules = params[:day_of_month_or_week_monthly] == 'day_of_month' ? [] : {} if type == 'Monthly' && rules.blank?
      rules = { '1' => (params[:day_of_month_or_week_yearly] == 'day_of_month' ? [] : {}) } if type == 'Yearly' && rules.blank?
      params[:transaction_purpose][:recurrence_rule_attributes][:rules] = rules
      params.require(:transaction_purpose).permit(:name, :estimate, :sub_category_id, :credit, recurrence_rule_attributes: {}) # TODO: Allow selected params in nested attrs
    end
end
