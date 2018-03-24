class Payment < ApplicationRecord
  PAYMENT_MODES = {
    OT: 'Online Transfer',
    DC: 'Debit Card',
    CC: 'Credit Card',
    EC: 'ECS',
    UP: 'UPI',
    CQ: 'Cheque',
    CS: 'Cash'
  }

  belongs_to :transaxion, class_name: 'Transaction' # Workaround for error "You tried to define an association named transaction on the model Payment, but this will conflict with a method transaction already defined by Active Record. Please choose a different association name."

end
