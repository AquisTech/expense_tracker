class HomeController < ApplicationController
  def index
    # transaction_purposes = TransactionPurpose.for(Date.today || params[:date])
    transaction_purposes = TransactionPurpose.first(5)
    @transactions = []
    transaction_purposes.each do |tp|
      @transactions << (tp.transactions.present? ? tp.transactions : tp.transactions.build) # add scope in tp.transactions.for(Date.today || params[:date])
    end
    @transactions << Transaction.new
    puts '=====================', @transactions.inspect
  end
end
