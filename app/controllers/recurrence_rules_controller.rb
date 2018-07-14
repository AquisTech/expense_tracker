class RecurrenceRulesController < ApplicationController
  before_action :set_recurrence_rule, only: [:show, :edit, :update, :destroy]

  def index
    @recurrence_rules = RecurrenceRule.first(30) + RecurrenceRule.last(30)
  end

  def new
    @recurrence_rule = RecurrenceRule.new
    render layout: false
  end

  def create
    @recurrence_rule = RecurrenceRule.new(recurrence_rule_params)
    if @recurrence_rule.save
      redirect_to recurrence_rules_url, notice: 'Recurrence rule was successfully created.'
    else
      render_failure(@recurrence_rule)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @recurrence_rule.update(recurrence_rule_params)
      redirect_to recurrence_rules_url, notice: 'Recurrence rule was successfully updated.'
    else
      render_failure(@recurrence_rule)
    end
  end

  def show
    render layout: false
  end

  def destroy
    @recurrence_rule.destroy
    redirect_to recurrence_rules_url, notice: 'Recurrence rule was successfully destroyed.'
  end

  private
    def set_recurrence_rule
      @recurrence_rule = RecurrenceRule.find(params[:id])
    end

    def recurrence_rule_params
      params.require(:recurrence_rule).permit(:type, :interval, :starts_on, :ends_on, :count, :rules, :transaction_purpose_id)
    end
end
