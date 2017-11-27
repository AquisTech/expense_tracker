class TransactionPurposesController < ApplicationController
  before_action :set_transaction_purpose, only: [:show, :edit, :update, :destroy]

  def index
    @transaction_purposes = TransactionPurpose.all
  end

  def new
    @transaction_purpose = TransactionPurpose.new
    @transaction_purpose.build_recurrence_rule
    render layout: false
  end

  def create
    @transaction_purpose = TransactionPurpose.new(transaction_purpose_params)
    if @transaction_purpose.save
      redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully created.'
    else
      render :new
    end
  end

  def edit
    render layout: false
  end

  def update
    if @transaction_purpose.update(transaction_purpose_params)
      redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully updated.'
    else
      render :edit
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
    # byebug
    rule = RecurrenceRule.new(type: params[:type], interval: params[:interval].to_i, rules: params[:rules])
    msg = 'aaaa'
    msg = rule.humanize rescue 'rescue'
    puts '----------------', msg, '------------------------------'
    render json: {msg: msg}, status: :ok
  end

  private
    def set_transaction_purpose
      @transaction_purpose = TransactionPurpose.find(params[:id])
    end

    def transaction_purpose_params
      params.require(:transaction_purpose).permit(:name, :sub_category_id, recurrence_rule_attributes: {} )
    end
end
