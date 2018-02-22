class HomeController < ApplicationController
  def index
    # transaction_purposes = TransactionPurpose.for(Date.today || params[:date])
    transaction_purposes = TransactionPurpose.first(5)
    @transactions = [Transaction.new]
    # TODO: Keep new on top and filled ones below
    transaction_purposes.each do |tp|
      @transactions << (tp.transactions.present? ? tp.transactions : tp.transactions.build) # add scope in tp.transactions.for(Date.today || params[:date])
    end
    puts '=====================', @transactions.inspect
  end
end
