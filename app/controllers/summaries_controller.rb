class SummariesController < ApplicationController
  def show
    @year = Date.parse("JAN-#{params[:year]}") if params[:year] rescue raise 'Invalid year'
    @month = Date.parse(params[:month]) if params[:month] rescue raise 'Invalid month'
    @date = if @year
      @year.beginning_of_year..@year.end_of_year
    elsif @month
      @month.beginning_of_month..@month.end_of_month
    else
      Date.parse(params[:date]) rescue Date.today
    end
    @transactions = current_user.transactions.where(transacted_at: @date)
    @estimated_expense = if (@month || @year)
      expense = current_user.expenses.where(starts_on: @date.first, ends_on: @date.last).first_or_initialize
      if expense.updated_at.nil? || expense.updated_at < TransactionPurpose.select("max(updated_at) latest_updated").group('id').first.latest_updated
        expense.recalculate_amount(@date.first, @date.last)
      else
        expense.amount
      end
    else
      current_user.occurrences.joins(:recurrence_rule)
        .joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id")
        .for(@date).sum(:estimate)
    end
  end
end
