require 'rails_helper'

# => V I E W S    C O N T E N T
def expect_index current_user
  expect(page).to have_content( I18n.t('action.index', model: Category.model_name.human.pluralize) )

  expect(page).to have_content( Category.human_attribute_name(:name) )
  expect(page).to have_content( Category.human_attribute_name(:description) )

  if current_user.categories.size > 0
    expect(page).to have_content( current_user.categories.first.name )
    expect(page).to have_content( current_user.categories.first.description )
    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")

    expect(page).to have_content( I18n.t('action.per_page', model: Account.model_name.human.pluralize) )
    expect(page).to have_selector('select#per_page')
  
    if current_user.accounts.count == 1
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    elsif current_user.accounts.count > 25
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "1", to: "25", count: current_user.categories.count) )
    else    
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.other', count: current_user.categories.count) )
    end
  end

  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Category.model_name.human) )
end

def expect_new
  expect(page).to have_content( I18n.t('action.new_fem', model: Category.model_name.human) )
  expect(page).to have_content( Category.human_attribute_name(:name) )
  expect(page).to have_selector("input#category_name")
  expect(page).to have_content( Category.human_attribute_name(:description) )
  expect(page).to have_selector("textarea#category_description")

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_edit category
  expect(page).to have_content( I18n.t('action.edit', model: Category.model_name.human) )
  expect(page).to have_content( Category.human_attribute_name(:name) )
  expect(page).to have_field( Category.human_attribute_name(:name), with: category.name )
  expect(page).to have_content( Category.human_attribute_name(:description) )
  expect(page).to have_field( Category.human_attribute_name(:description), with: category.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_show category
  expect(page).to have_content( Category.model_name.human.pluralize )
  expect(page).to have_content( Category.human_attribute_name(:name) )
  expect(page).to have_content( category.name )
  expect(page).to have_content( Category.human_attribute_name(:description) )
  expect(page).to have_content( category.description )
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
end



# => O W N E R    U S E R
feature "categories views for owner user", type: :feature do
  given!(:current_user){ create(:user) }
  given!(:category){ create(:category, user: current_user) }

  background :each do
    login current_user
  end

  # => I N D E X
  scenario "listing user categories" do
    visit user_categories_path(current_user)
    expect_index current_user
  end

  # => N E W    A N D    C R E A T E
  context "creating a new category" do
    scenario "with valid params" do
      visit new_user_category_path(current_user)

      expect_new
      fill_in :category_name, with: "Entertainment"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.created_fem', model: Category.model_name.human) )
      expect_show Category.find_by(name: "Entertainment")
    end

    scenario "with invalid params" do
      visit new_user_category_path(current_user)

      fill_in :category_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      expect_new
    end
  end
  
  # => S H O W
  scenario "showing category" do
    visit category_path(category)
    expect_show category
  end

  # => E D I T    A N D   U P D A T E
  context "updating category" do
    scenario "with valid params" do
      visit edit_category_path(category)

      expect_edit category
      fill_in :category_name, with: "Car"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated_fem', model: Category.model_name.human) )
      category.name = "Car"
      category.save
      expect_show category
    end

    scenario "with invalid params" do
      visit edit_category_path(category)

      fill_in :category_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      category.name = ""
      category.save
      expect_edit category
    end
  end

  # => D E S T R O Y
  scenario "removing category" do
    visit user_categories_path(current_user)

    expect_index current_user
    first('.btn-danger').click

    expect(page).to have_content( I18n.t('controller.destroyed_fem', model: Category.model_name.human) )
    expect_index current_user
  end

  # => P A G I N A T I O N 
  context "pagination" do
    let!(:current_user) { create(:user) }

    # def reset_database current_user
    #   current_user.accounts.destroy_all
    # end

    def create_records
      for var in 0..30
        create(:category, user: current_user)
      end
    end

    background :each do
      # reset_database current_user
      login current_user
      visit user_categories_path(current_user)
    end

    scenario "if there is more than 25 records, must have a button to second page" do
      expect_index current_user
      expect(page).to_not have_css('ul.pagination')

      create_records
      visit user_categories_path(current_user)
      expect_index current_user
      expect(page).to have_selector(:link_or_button, '2')
      expect(page).to have_css('ul.pagination')
      click_on '2'

      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "26", to: current_user.categories.count, count: current_user.categories.count) )
    end
  end
end



# => A D M I N    U S E R
feature "another user categories views for admin user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:category){ create(:category, user: user_owner) }

  background :each do
    current_user = login create(:user, admin: true)
    visit user_categories_path(user_owner)
  end

  # => I N D E X   A N d    D E S T R O Y
  scenario "can't list categories" do
    expect(page).to_not have_content( I18n.t('action.index', model: Category.model_name.human.pluralize) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    AND   C R E A T E
  scenario "can't access to create a new category" do
    visit new_user_category_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new_fem', model: Category.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an category" do
    visit category_path(category)
    expect(page).to_not have_content(category.name)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't access to update an category" do
    visit edit_category_path(category)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Category.human_attribute_name(:name) )
  end
end



# => A N O T H E R   N O R M A L    U S E R
feature "a user categories views for another normal user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:category){ create(:category, user: user_owner) }

  background :each do
    current_user = login create(:user)
    visit user_categories_path(user_owner)
  end

  # => I N D E X   A N d    D E S T R O Y
  scenario "can't list categories" do
    expect(page).to_not have_content( I18n.t('action.index', model: Category.model_name.human.pluralize) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    AND   C R E A T E
  scenario "can't access to create a new category" do
    visit new_user_category_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new_fem', model: Category.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an category" do
    visit category_path(category)
    expect(page).to_not have_content(category.name)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't acess to update an category" do
    visit edit_category_path(category)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Category.human_attribute_name(:name) )
  end
end
