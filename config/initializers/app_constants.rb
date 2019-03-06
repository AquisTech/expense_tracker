SUBCATEGORIES = SubCategory.includes(:category).all
SUBCATEGORIES_COUNT = SubCategory.count(:id)