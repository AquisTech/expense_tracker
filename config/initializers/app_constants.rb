if Rails.const_defined?('Server') && ActiveRecord::Base.connection.table_exists?('sub_categories')
  SUBCATEGORIES = SubCategory.includes(:category).all
  SUBCATEGORIES_COUNT = SubCategory.count(:id)
end