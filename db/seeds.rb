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
['Food', 'Travel'].each do |cat|
  Category.where(name: cat).first_or_create
end
[

].each do |sub_cat|
  SubCategory.create()
end
