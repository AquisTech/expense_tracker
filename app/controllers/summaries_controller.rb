class SummariesController < ApplicationController
  def show
    @year = Date.parse("JAN-#{params[:year]}") if params[:year] rescue raise 'Invalid year'
    @month = Date.parse(params[:month]) if params[:month] rescue raise 'Invalid month'
    # TODO : Make provision for weekly
    @date = if @year
      @year.beginning_of_year..@year.end_of_year
    elsif @month
      @month.beginning_of_month..@month.end_of_month
    else
      Date.parse(params[:date]) rescue Date.today
    end
    @transactions = current_scope.transactions.where(transacted_at: @date)
    @estimated_credits, @estimated_debits = if (@month || @year)
      expense = current_scope.expenses.where(starts_on: @date.first, ends_on: @date.last).first_or_initialize
      if expense.updated_at.nil? || expense.updated_at < current_scope.transaction_purposes.select("max(updated_at) latest_updated").order('user_id').group('user_id').first.latest_updated
        expense.recalculate_amount(@date.first, @date.last)
      end
      [expense.credits, expense.debits]
    else
      [current_scope.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(@date).where(transaction_purposes: {credit: true}).sum(:estimate),
      current_scope.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(@date).where(transaction_purposes: {credit: false}).sum(:estimate)]
    end
    @actual_expenses = @transactions.sum("#{ActiveRecord::Base.CASE_WHEN('credit = true', 'amount', '-1 * amount')}")
  end
end
