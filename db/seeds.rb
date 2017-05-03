# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

[
  {name: 'SBI Saving Bank Account', account_type: 'SB'},
  {name: 'HDFC Saving Bank Account', account_type: 'SB'},
  {name: 'ICICI Saving Bank Account', account_type: 'SB'},
  {name: 'StanC Saving Bank Account', account_type: 'SB'},
  {name: 'HDFC Credit Card Account', account_type: 'CC'},
  {name: 'PayTM', account_type: 'EW'},
  {name: 'Mobikwik', account_type: 'EW'},
  {name: 'OlaMoney', account_type: 'EW'},
  {name: 'R Wallet', account_type: 'EW'},
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
  'Entertainment': ['Concert', 'Movie', 'Drama/Play', 'Party', 'Sports', 'Other'],
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
  'Interest': ['Savings Account', 'Fixed Deposit', 'Recurring Deposit']
}.each do |category, sub_categories|
  c = Category.where(name: category).first_or_create
  sub_categories.each do |sub_category|
    c.sub_categories.where(name: sub_category).first_or_create
  end
end
