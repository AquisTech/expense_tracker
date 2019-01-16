class SummariesController < ApplicationController
  def show
    @date = Date.parse(params[:date]) rescue Date.today
    @transactions = Transaction.where(transacted_at: @date)
  end
end
