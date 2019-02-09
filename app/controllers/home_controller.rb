class HomeController < ApplicationController
  # def index
  #   # TODO: transaction_purposes = TransactionPurpose.for(Date.today || params[:date])
  #   transaction_purposes = TransactionPurpose.first(5)
  #   transaction = Transaction.new
  #   transaction.payments.build
  #   @transactions = [transaction]
  #   # TODO: Keep new on top and filled ones below
  #   transaction_purposes.each do |tp|
  #     if tp.transactions.present?
  #       tp.transactions.each { |t| @transactions << t }
  #     else
  #       transaction = tp.transactions.build
  #       transaction.payments.build
  #       @transactions << transaction # TODO: add scope in tp.transactions.for(Date.today || params[:date])
  #     end
  #   end
  #   # TODO: Change above logic instead of looping only fetch collect of today's transaction and place them at bottom.
  #   puts '=====================', @transactions.inspect
  # end

  def index
    @date = Date.parse(params[:date]) rescue Date.today
    # TODO: transaction_purposes = TransactionPurpose.for(params[:date] || Date.today)
    transaction = current_user.transactions.new
    transaction.payments.build
    @transactions = [transaction]
    transfer = current_user.transfers.new
    @transactions << transfer
    occurrences = current_user.occurrences.for(@date)
    # TODO: Keep new on top and filled ones below
    occurrences.each do |occurrence|
      tp = occurrence.transaction_purpose
      if tp.transfer?
        if tp.transfers.where(transacted_at: @date.all_day).present?
          tp.transfers.where(transacted_at: @date.all_day).each { |t| @transactions << t }
        else
          transfer = tp.transfers.build
          @transactions << transfer
        end
      else
        if tp.transactions.where(transacted_at: @date.all_day).present?
          tp.transactions.where(transacted_at: @date.all_day).each { |t| @transactions << t }
        else
          transaction = tp.transactions.build
          transaction.payments.build
          @transactions << transaction # TODO: add scope in tp.transactions.for(Date.today || params[:date])
        end
      end
    end
    # TODO: Change above logic instead of looping only fetch collect of today's transaction and place them at bottom.
    puts '=====================', @transactions.inspect
  end
end
