class PaymentSource < ApplicationRecord
  PAYMENT_MODES = {
    OT: 'Online Transfer',
    DC: 'Debit Card',
    CC: 'Credit Card',
    EC: 'ECS',
    UP: 'UPI',
    CS: 'Cash'
  }
end
