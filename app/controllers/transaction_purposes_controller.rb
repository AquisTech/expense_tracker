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
    tp = TransactionPurpose.new(transaction_purpose_params)
    begin
      msg = tp.humanize
    rescue Exception => e
      msg = "#{e.message} | #{e.backtrace}"
    end
    render json: { msg: msg }, status: :ok
  end

  def get_estimate
    tp = TransactionPurpose.find(params[:id])
    render json: tp.estimate, status: :ok
  end

  private
    def set_transaction_purpose
      @transaction_purpose = TransactionPurpose.find(params[:id])
    end

    def remove_blanks(hash)
      hash.each { |k, v| v.is_a?(Array) ? hash[k] = v.without('') : remove_blanks(v) }
      hash.reject! { |k, v| v.blank? }
      hash
    end

    def transaction_purpose_params
      rule = params[:transaction_purpose][:recurrence_rule_attributes][:rules].dup
      rule = rule.without('') if rule.present? && rule.include?('')
      remove_blanks(rule) unless rule.is_a?(Array)
      params[:transaction_purpose][:recurrence_rule_attributes][:rules] = rule || []
      params.require(:transaction_purpose).permit(:name, :estimate, :sub_category_id, recurrence_rule_attributes: {} )
    end
end
