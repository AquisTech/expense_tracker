class RecurrenceRulesController < ApplicationController
  before_action :set_recurrence_rule, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @recurrence_rules = pagy(current_user.recurrence_rules)
  end

  def new
    @recurrence_rule = current_user.recurrence_rules.new
    render layout: false
  end

  def create
    @recurrence_rule = current_user.recurrence_rules.new(recurrence_rule_params)
    if @recurrence_rule.save
      redirect_to recurrence_rules_path, notice: 'Recurrence rule was successfully created.'
    else
      render_failure(@recurrence_rule)
    end
  end

  def update
    if @recurrence_rule.update(recurrence_rule_params)
      redirect_to recurrence_rules_path, notice: 'Recurrence rule was successfully updated.'
    else
      render_failure(@recurrence_rule)
    end
  end

  def destroy
    @recurrence_rule.destroy
    redirect_to recurrence_rules_path, notice: 'Recurrence rule was successfully destroyed.'
  end

  private
    def set_recurrence_rule
      @recurrence_rule = current_user.recurrence_rules.find(params[:id])
    end

    def recurrence_rule_params
      params.require(:recurrence_rule).permit(:type, :interval, :starts_on, :ends_on, :count, :rules, :transaction_purpose_id)
    end
end
