class SummariesController < ApplicationController
  def show
    @year = Date.parse("JAN-#{params[:year]}") if params[:year] rescue raise 'Invalid year'
    @month = Date.parse(params[:month]) if params[:month] rescue raise 'Invalid month'
    if @year
      @date = @year.beginning_of_year..@year.end_of_year
    elsif @month
      @date = @month.beginning_of_month..@month.end_of_month
    else
      @date = Date.parse(params[:date]) rescue Date.today
    end
    @transactions = Transaction.where(transacted_at: @date)
  end
end
