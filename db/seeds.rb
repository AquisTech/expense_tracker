# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

[
  {name: 'SBI Saving Bank Account', account_type: 'SB'},
  {name: 'HDFC Saving Bank Account', account_type: 'SB'},
  {name: 'ICICI Saving Bank Account', account_type: 'SB'},
  {name: 'StanC Saving Bank Account', account_type: 'SB'},
  {name: 'HDFC Credit Card Account', account_type: 'CC'},
  {name: 'CITI Credit Card Account', account_type: 'CC'},
  {name: 'TATA Croma Credit Card Account', account_type: 'CC'},
  {name: 'SBI FBB Credit Card Account', account_type: 'CC'},
  {name: 'PayTM', account_type: 'EW'},
  {name: 'Mobikwik', account_type: 'EW'},
  {name: 'OlaMoney', account_type: 'EW'},
  {name: 'R Wallet', account_type: 'EW'},
  {name: 'ICICI Pockets', account_type: 'EW'},
  {name: 'HDFC Payzapp', account_type: 'EW'},
  {name: 'PhonePe', account_type: 'EW'},
  {name: 'ATVM Card', account_type: 'SC'},
  {name: 'ICICI Food Card', account_type: 'SC'},
  {name: 'Cash', account_type: 'CS'}
].each do |acc|
  Account.where(
    name: acc[:name], account_type: acc[:account_type],
    description: acc[:description] || acc[:name],
    details: acc[:details] || acc[:name]
  ).first_or_create
end
{
  # Expenses / Debits
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
  'Travel': ['Aeroplane', 'Train', 'Metro', 'Monorail', 'Bullet Train', 'Bus', 'Auto-rikshaw', 'Taxi', 'Cab', 'Rented Vehicle', 'Toll'],
  'Utilities': ['Cable TV', 'Dish TV', 'Electricity', 'Gas', 'Internet', 'Water', 'Telephone', 'Mobile'],
  'Vacation': ['Aeroplane', 'Train', 'Metro', 'Monorail', 'Bullet Train', 'Bus', 'Auto-rikshaw', 'Taxi', 'Cab', 'Rented Vehicle', 'Toll', 'Hotel'],
  # Incomes / Credits
  'Salary': ['Full-time Job', 'Part-time Job'],
  'Rent': ['Office', 'House', 'Farm-house', 'Vehicle'],
  'Interest': ['Savings Account', 'Fixed Deposit', 'Recurring Deposit'],
  'Share Market': ['Mutual Funds Dividend']
}.each do |category, sub_categories|
  c = Category.where(name: category).first_or_create
  (sub_categories << 'Other').each do |sub_category|
    c.sub_categories.where(name: sub_category).first_or_create
  end
end
{
  Daily:   [{interval: [1,2,7]}],
  Weekly:  [ # 0 = Sunday, 1 = Monday, ....., 6 = Saturday
             {interval: [1,3], rules: [1]},
             {interval: [1,3], rules: [1, 3]},
             {interval: [1,3], rules: [1, 3, 4]},
             {interval: [1,3], rules: [1, 2, 3, 4, 5]},
             {interval: [1,3], rules: [0, 6]}
           ],
  Monthly: [
            {interval: [1,2], rules: [1]},
            {interval: [1,2], rules: [3]},
            {interval: [1,2], rules: [-1]},
            {interval: [1,2], rules: [3, 9]},
            {interval: [1,2], rules: [3, 9, 10]},
            {interval: [1,2], rules: [3, 9, -1]},
            # {day_number => [week_numbers]}
            {interval: [1,2], rules: {5 => [2]}},
            {interval: [1,2], rules: {5 => [-1]}},
            {interval: [1,2], rules: {5 => [2, 4]}},
            {interval: [1,2], rules: {5 => [1, 2, 4]}},
            {interval: [1,2], rules: {5 => [2], 4 => [2]}},
            {interval: [1,2], rules: {5 => [-1], 4 => [-1]}},
            {interval: [1,2], rules: {5 => [2, 4], 4 => [2, 4]}},
            {interval: [1,2], rules: {1 => [2], 2 => [3]}},
            {interval: [1,2], rules: {0 => [2], 6 => [2]}},
            {interval: [1,2], rules: {0 => [-1], 6 => [-1]}},
            {interval: [1,2], rules: {0 => [2,4], 6 => [2,4]}},
            {interval: [3,6], rules: [15]}
           ],
  Yearly: [ # {month_number => [day_numbers]}
            {interval: [1,2], rules: {2 => [1]}},
            {interval: [1,2], rules: {2 => [1, 5]}},
            {interval: [1,2], rules: {2 => [1, 5], 4 => [1, 5]}},
            {interval: [1,2], rules: {2 => [1], 3 => [3]}},
            {interval: [1,2], rules: {2 => [1, 6], 3 => [3, 9]}},
          ]
}.each do |type, conditions_array|
  conditions_array.each do |conditions|
    conditions[:interval].each do |interval|
      r = RecurrenceRule.create(type: type, interval: interval, rules: conditions[:rules])
      puts r.humanize
    end
  end
end
