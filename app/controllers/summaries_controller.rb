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
    @transactions = Transaction.where(transacted_at: @date)
    @estimated_expense = Occurrence.joins(:recurrence_rule).joins("INNER JOIN transaction_purposes ON recurrence_rules.transaction_purpose_id = transaction_purposes.id").for(@date).sum(:estimate) unless (@month || @year)
  end
end
