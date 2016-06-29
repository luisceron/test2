module CategoriesHelper
  def category_form_path category
    if category.new_record?
      user_categories_path category.user
    else
      category_path category
    end
  end

  def user_categories_for_select user
    user.categories.collect do |category|
      [category.name, category.id]
    end
  end
end
