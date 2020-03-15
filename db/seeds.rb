# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
puts "Adding Categories..."
{
  # Expenses / Debits # TODO: Add column for credit debit type
  'Automobile': [],
  'Entertainment': ['Concert', 'Movie', 'Drama/Play', 'Party', 'Sports'],
  'Family': [],
  'Food': ['Breakfast', 'Lunch', 'Snacks', 'Dinner', 'Groceries', 'Tea/Coffee/Juice'],
  'Health Care': ['Dental Care', 'Eye Care', 'Health Insurance', 'Medicines', 'Nutrition', 'Skin Care'],
  'Household': ['Appliances', 'Home Maintenance', 'Household Tools', 'Miscellaneous Household Items', 'Rent', 'Home Loan EMI', 'Home Insurance', 'Servant'],
  'Insurance': ['Automobile', 'Health', 'Home', 'Life'],
  'Loan': ['Automobile', 'Home', 'Mortgage', 'Education', 'Business', 'Property'],
  'Personal': ['Clothing', 'Gift', 'Personal Care'],
  'Tax': ['Property Tax', 'Income Tax'],
  'Travel': ['Aeroplane', 'Train', 'Metro', 'Monorail', 'Bullet Train', 'Bus', 'Auto-rikshaw', 'Taxi', 'Cab', 'Rented Vehicle', 'Toll', 'Car Pool'],
  'Utilities': ['Cable TV', 'Dish TV', 'Electricity', 'Gas', 'Internet', 'Water', 'Telephone', 'Mobile'],
  'Vacation': ['Aeroplane', 'Train', 'Metro', 'Monorail', 'Bullet Train', 'Bus', 'Auto-rikshaw', 'Taxi', 'Cab', 'Rented Vehicle', 'Toll', 'Hotel'],
  # Incomes / Credits
  'Salary': ['Full-time Job', 'Part-time Job'],
  'Rent': ['Office', 'House', 'Farm-house', 'Vehicle'],
  'Interest': ['Savings Account', 'Fixed Deposit', 'Recurring Deposit'],
  'Share Market': ['Mutual Funds Dividend']
}.each do |category, sub_categories|
  c = Category.where(name: category).first_or_create!
  (sub_categories << 'Other').each do |sub_category|
    sc = c.sub_categories.where(name: sub_category).first_or_create!
    puts "#{category} - #{sub_category}"
  end
end
c = Category.where(name: 'Other').first_or_create!
['Unscheduled Credit', 'Unscheduled Debit'].each do |sub_category|
  c.sub_categories.where(name: sub_category).first_or_create!
  puts "#{c.name} - #{sub_category}"
end
if Rails.env.development?

  def find_user
    @user ||= User.first
  end
  def create_default_user
    user = User.create("email"=>"anand@test.com", "password"=>"123456", "password_confirmation"=>"123456")
    find_user.confirm
  end
  create_default_user
  puts "Adding Accounts..."
  [
    { name: 'SBI Saving Bank Account', account_type: 'SB', payment_modes: ['OT', 'DC', 'CQ'] },
    { name: 'HDFC Saving Bank Account', account_type: 'SB', payment_modes: ['OT', 'DC', 'CQ'] },
    { name: 'ICICI Saving Bank Account', account_type: 'SB', payment_modes: ['OT', 'DC', 'EC', 'UP', 'CQ'] },
    { name: 'StanC Saving Bank Account', account_type: 'SB', payment_modes: ['OT', 'DC', 'UP', 'CQ'] },
    { name: 'HDFC Credit Card Account', account_type: 'CC', payment_modes: ['CC'] },
    { name: 'CITI Credit Card Account', account_type: 'CC', payment_modes: ['CC'] },
    { name: 'TATA Croma Credit Card Account', account_type: 'CC', payment_modes: ['CC'] },
    { name: 'SBI FBB Credit Card Account', account_type: 'CC', payment_modes: ['CC'] },
    { name: 'PayTM', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'Mobikwik', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'OlaMoney', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'R Wallet', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'ICICI Pockets', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'HDFC Payzapp', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'PhonePe', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'Google Pay', account_type: 'EW', payment_modes: ['EW'] },
    { name: 'ATVM Card', account_type: 'SC', payment_modes: ['EW'] },
    { name: 'ICICI Food Card', account_type: 'SC', payment_modes: ['EW'] },
    { name: 'Cash', account_type: 'CS', payment_modes: ['CS'] }
  ].each do |acc|
    next if acc[:name] == 'Cash'
    Account.where(
      name: acc[:name], account_type: acc[:account_type],
      description: acc[:description] || "#{acc[:name]} | #{Account::ACCOUNT_TYPES[acc[:account_type]]}",
      details: acc[:details] || "#{acc[:name]} | #{Account::ACCOUNT_TYPES[acc[:account_type]]}",
      user_id: find_user.id,
      payment_modes: acc[:payment_modes]
    ).first_or_create!
    puts "#{acc[:name]} - #{Account::ACCOUNT_TYPES[acc[:account_type]]}"
  end
  def find_accounts
    @accounts ||= find_user.accounts
  end
  
  # Create TransactionPurposes
  def create_transaction_purpose(params, duration_params, count = nil)
    duration_params = duration_params.deep_merge("recurrence_rule_attributes" => {count: count}) if count
    tp = TransactionPurpose.new(params.deep_merge(duration_params))
    tp.user_id = find_user.id
    tp.credit = [true, false].sample
    tp.recurrence_rule.user_id = find_user.id
    account = find_accounts.sample
    pay_mode = account.payment_modes.sample
    tp.preferred_payment_mode = pay_mode
    tp.preferred_account_id = account.id
    tp.preferred_dest_account_id = Account.where("payment_modes LIKE '%#{pay_mode}%' AND id != #{account.id}").ids.sample
    tp.name = 'TEST' + tp.humanize
    puts tp.humanize
    puts tp.save ? 'Saved' : tp.errors.full_messages.to_sentence
  end
  puts "Adding Transaction Purposes..."
  sub_categories = SubCategory.pluck(:id)
  {
    Daily:   [{interval: [1,2,7]}],
    Weekly:  [ # 0 = Sunday, 1 = Monday, ....., 6 = Saturday
               {interval: [1,3], rules: ['1']},
               {interval: [1,3], rules: ['1', '3']},
               {interval: [1,3], rules: ['1', '3', '4']},
               {interval: [1,3], rules: ['1', '2', '3', '4', '5']},
               {interval: [1,3], rules: ['0', '6']}
             ],
    Monthly: [# rules: [day_numbers]
              {interval: [1,2], rules: ['1']},
              {interval: [1,2], rules: ['3']},
              {interval: [1,2], rules: ['-1']},
              {interval: [3,6], rules: ['15']},
              {interval: [1,2], rules: ['3', '9']},
              {interval: [1,2], rules: ['3', '9', '10']},
              {interval: [1,2], rules: ['3', '9', '-1']},
              # rules: {day_of_week_number => [week_numbers]}
              {interval: [1,2], rules: {'5' => ['2']}},
              {interval: [1,2], rules: {'5' => ['-1']}},
              {interval: [1,2], rules: {'5' => ['2', '4']}},
              {interval: [1,2], rules: {'5' => ['1', '2', '4']}},
              {interval: [1,2], rules: {'5' => ['2'], '4' => ['2']}},
              {interval: [1,2], rules: {'5' => ['-1'], '4' => ['-1']}},
              {interval: [1,2], rules: {'5' => ['2', '4'], '4' => ['2', '4']}},
              {interval: [1,2], rules: {'1' => ['2'], '2' => ['3']}},
              {interval: [1,2], rules: {'0' => ['2'], '6' => ['2']}},
              {interval: [1,2], rules: {'0' => ['-1'], '6' => ['-1']}},
              {interval: [1,2], rules: {'0' => ['2', '4'], '6' => ['2', '4']}},
             ],
    Yearly: [ # rules: {month_number => [day_numbers]}
              {interval: [1,2], rules: {'2' => ['1']}},
              {interval: [1,2], rules: {'2' => ['1', '5']}},
              {interval: [1,2], rules: {'2' => ['15', '-1']}},
              {interval: [1,2], rules: {'2' => ['1', '5'], '4' => ['1', '5']}},
              {interval: [1,2], rules: {'2' => ['1'], '3' => ['3']}},
              {interval: [1,2], rules: {'2' => ['1', '6'], '3' => ['3', '9']}},
              # rules: {month_number => {day_of_week_number => [week_numbers]}}
              {interval: [1,2], rules: {'2' => {'4' => ['1']}}},
              {interval: [1,2], rules: {'2' => {'4' => ['1', '3']}}},
              {interval: [1,2], rules: {'2' => {'4' => ['1', '3']}, '7' => {'4' => ['1', '3']}}},
              {interval: [1,2], rules: {'2' => {'5' => ['2', '3']}, '7' => {'4' => ['1', '3']}}},
              {interval: [1,2], rules: {'2' => {'5' => ['1', '-1']}, '7' => {'4' => ['2', '-1']}}},
              {interval: [1,2], rules: {'2' => {'0' => ['2', '-1']}, '7' => {'6' => ['2', '-1']}}},
              {interval: [1,2], rules: {'2' => {'0' => ['2', '-1'], '6' => ['2', '-1']}, '7' => {'0' => ['2', '-1'], '6' => ['2', '-1']}}},
            ]
  }.each do |type, conditions_array|
    conditions_array.each do |conditions|
      conditions[:interval].each do |interval|
        params =  {
          "sub_category_id"=> sub_categories.sample,
          'estimate' => [10, 20, 30].sample,
          "recurrence_rule_attributes"=>{
            "type"=> type,
            "interval"=> interval,
            "rules"=> conditions[:rules]
          }
        }

        duration_params = {"recurrence_rule_attributes" => {
          "starts_on(3i)"=>"18", "starts_on(2i)"=>"2", "starts_on(1i)"=>"2018", "starts_on(4i)"=>"17", "starts_on(5i)"=>"26",
          "ends_on(3i)"=>"25", "ends_on(2i)"=>"3", "ends_on(1i)"=>"2018", "ends_on(4i)"=>"17", "ends_on(5i)"=>"26"
        }}
        create_transaction_purpose(params, duration_params)
        create_transaction_purpose(params, duration_params, 1)
        create_transaction_purpose(params, duration_params, 2)

        duration_params = {"recurrence_rule_attributes" => {
          "starts_on(3i)"=>"18", "starts_on(2i)"=>"2", "starts_on(1i)"=>"2018", "starts_on(4i)"=>"17", "starts_on(5i)"=>"26"
        }}
        create_transaction_purpose(params, duration_params)
        create_transaction_purpose(params, duration_params, 1)
        create_transaction_purpose(params, duration_params, 2)
      end
    end
  end
end
