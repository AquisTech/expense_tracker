class HomeController < ApplicationController
  def index
    # TODO: transaction_purposes = TransactionPurpose.for(Date.today || params[:date])
    transaction_purposes = TransactionPurpose.first(5)
    transaction = Transaction.new
    transaction.payments.build
    @transactions = [transaction]
    # TODO: Keep new on top and filled ones below
    transaction_purposes.each do |tp|
      if tp.transactions.present?
        tp.transactions.each { |t| @transactions << t }
      else
        transaction = tp.transactions.build
        transaction.payments.build
        @transactions << transaction # TODO: add scope in tp.transactions.for(Date.today || params[:date])
      end
    end
    # TODO: Change above logic instead of looping only fetch collect of today's transaction and place them at bottom.
    puts '=====================', @transactions.inspect
  end
end
