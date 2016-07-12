require 'rails_helper'

def reset_database
  User.destroy_all
end

# => V I E W S    C O N T E N T
def expect_index
  expect(page).to have_selector(:link_or_button, User.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.index', model: User.model_name.human.pluralize) )

  expect(page).to have_selector('input#q_email_or_name_cont')
  expect(page).to have_css('button.btn.btn-sm.btn-primary .fa.fa-search')

  expect(page).to have_content( User.human_attribute_name(:email) )
  expect(page).to have_content( User.human_attribute_name(:name) )
  expect(page).to have_content( User.human_attribute_name(:admin) )

  if User.all.size > 0
    user_admin  = User.where(admin: true).first
    if user_admin
      expect(page).to have_content( user_admin.email )
      expect(page).to have_content( user_admin.name )
      expect(page).to have_css( "div.label.label-success")
    end

    user_normal = User.where(admin: false).first
    if user_normal
      expect(page).to have_content( user_normal.email )
      expect(page).to have_content( user_normal.name )
    end

    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")
  end
  expect(page).to have_css('#new_user_button')

  expect(page).to have_content( I18n.t('action.per_page', model: User.model_name.human.pluralize) )
  expect(page).to have_selector('select#per_page')

  if User.all.count == 1
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
  elsif User.all.count > 25
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "1", to: "25", count: User.all.count) )
  else    
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.other', count: User.all.count) )
  end
end

def expect_new
  expect(page).to have_content( I18n.t('action.new', model: User.model_name.human) )
  expect(page).to have_content( User.human_attribute_name(:email) )
  expect(page).to have_css("input#user_email")
  expect(page).to have_content( User.human_attribute_name(:admin) )
  expect(page).to have_selector("input#user_admin")
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )

  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_edit current_user, user
  expect(page).to have_content( I18n.t('action.edit', model: User.model_name.human) )
  expect(page).to have_content(user.email)
  expect(page).to_not have_css("input#user_email")
  expect(page).to have_field( User.human_attribute_name(:name), with: user.name )

  expect(page).to have_content( User.human_attribute_name(:admin) )

  if current_user.admin
    expect(page).to have_selector("input#user_admin")
    if user.admin
      find('input#user_admin').should be_checked
    else
      find('input#user_admin').should_not be_checked
    end
  else
    expect(page).to_not have_selector("input#user_admin")
  end

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )

  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_show current_user, user
  expect(page).to have_content( User.model_name.human.pluralize )
  expect(page).to have_content(user.name)
  expect(page).to have_content(user.email)

  if current_user.admin
    if user.admin
      expect(page).to have_css( "div.label.label-success")
    else
      expect(page).to_not have_css( "div.label.label-success")
    end
  else
    expect(page).to_not have_css( "div.label.label-success")
  end

  expect(page).to have_content(I18n.l user.created_at, format: :long)
  expect(page).to have_content(I18n.l user.updated_at, format: :long)
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') ) if user.admin
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.change_password') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.remove_account') )
end

def expect_login
  expect(page).to have_content( I18n.t('devise.shared.links.sign_in') )
  expect(page).to have_css("input#user_email")
  expect(page).to have_css("input#user_password")
  expect(page).to have_content( User.human_attribute_name(:remember_me) )
  expect(page).to have_selector("input#user_remember_me")
  expect(page).to have_selector(:link_or_button, I18n.t('devise.shared.links.sign_in') )
  expect(page).to have_content( I18n.t('devise.sessions.not_yet') )
  expect(page).to have_selector(:link_or_button, I18n.t('devise.shared.links.sign_up') )
  expect(page).to have_selector(:link_or_button, I18n.t('devise.shared.links.forgot_your_password') )
  expect(page).to have_selector(:link_or_button, I18n.t('devise.shared.links.didn_t_receive_confirmation_instructions') )
  expect(page).to have_selector(:link_or_button, I18n.t('devise.shared.links.didn_t_receive_unlock_instructions') )
end

def expect_edit_password current_user, user
  expect(page).to have_content( User.model_name.human.pluralize )
  expect(page).to have_content( I18n.t('link.change_password') )
  expect(page).to have_content( user.name )
  if current_user.admin
    expect(page).to_not have_css("input#user_current_password")
  else
    expect(page).to have_css("input#user_current_password")
  end
  expect(page).to have_css("input#user_password")
  expect(page).to have_css("input#user_password_confirmation")
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
end

def expect_destroy_account
  expect(page).to have_content( User.human_attribute_name(:destroy_message) )
  expect(page).to have_css("input#user_typed_email")
  expect(page).to have_selector(:link_or_button, I18n.t('link.cancel') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.remove_account') )
end



# => A D M I N    U S E R
feature "users views for admin user" do
  before :all do
    reset_database
  end

  given!(:user){ create(:user) }
  given!(:current_user){ create(:user, admin: true) }

  background :each do
    login current_user
  end

  # => I N D E X
  scenario "listing users" do
    visit users_path
    expect_index
  end

  # => N E W    A N D    C R E A T E
  context "creating a new user" do
    scenario "with valid params" do
      visit new_user_path

      expect_new
      fill_in :user_email, with: "luis@simplefinance.com"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.created', model: User.model_name.human) )
      expect_show current_user, User.find_by(email: "luis@simplefinance.com")
    end

    scenario "with invalid params" do
      visit new_user_path

      fill_in :user_email, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      expect_new
    end
  end
  
  # => S H O W
  scenario "showing user" do
    visit "/users/#{user.id}"

    expect_show current_user, user
  end

  # => U P D A T E
  context "updating user" do
    scenario "with valid params" do
      visit "/users/#{user.id}/edit"

      expect_edit current_user, user
      fill_in :user_name, with: "Marco"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated', model: User.model_name.human) )
      expect_show current_user, user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}/edit"

      fill_in :user_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      user.name = ""
      user.save
      expect_edit current_user, user
    end
  end

  # => D E S T R O Y
  scenario "removing user" do
    visit users_path

    expect_index
    first('.btn-danger').click

    expect(page).to have_content( I18n.t('controller.destroyed', model: User.model_name.human) )
    expect_index
  end

  # => D E S T R O Y    S E S S I O N
  scenario "signing out" do
    visit users_path

    expect_index
    click_on I18n.t('link.logout')

    expect(page).to have_content( I18n.t('devise.sessions.signed_out') )
    expect_login
  end

  # => U P D A T E    P A S S W O R D
  context "updating user password" do
    scenario "with valid params" do
      visit "/users/#{user.id}"

      expect_show current_user, user
      click_on I18n.t('link.change_password')
      expect_edit_password current_user, user

      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "12341234"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.password_changed') )
      expect_show current_user, user
    end

    scenario "admin update his own password with valid params" do
      visit "/users/#{current_user.id}"

      expect_show current_user, current_user
      click_on I18n.t('link.change_password')
      expect_edit_password current_user, current_user

      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "12341234"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.password_changed') )
      expect_show current_user, current_user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}"

      click_on I18n.t('link.change_password')
      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "11112222"
      click_on I18n.t('link.save')

      expect(page).to have_content( User.human_attribute_name(:admin_update_password_error) )
      expect_edit_password current_user, user
    end
  end

  # => D E S T R O Y    A C C O U N T
  context "destroyng user account" do
    scenario "with valid email" do
      visit "/users/#{user.id}"

      expect_show current_user, user
      find('a.btn.btn-danger').click
      expect_destroy_account
      fill_in :user_typed_email, with: user.email
      find('button.btn.btn-danger').click

      expect(page).to have_content( User.human_attribute_name(:destroyed_successfully) )
      expect(page).to_not have_content(user.email)
      expect(page).to_not have_content(user.name)
    end

    scenario "with invalid email" do
      visit "/users/#{user.id}"

      find('a.btn.btn-danger').click
      fill_in :user_typed_email, with: "Anything"
      find('button.btn.btn-danger').click

      expect(page).to have_content( User.human_attribute_name(:invalid_email) )
      expect_show current_user, user
    end
  end

  # => S E A R C H  A N D   P A G I N A T I O N 
  context "searching and pagination" do
    def create_records_email
      for var in 0..30
        create(:user, email: "user_test#{(var + 1).to_s}@test.com")
      end
    end

    def create_records_name
      for var in 0..30
        create(:user, email: "another#{(var + 1).to_s}@test.com")
      end
    end

    background :each do
      reset_database
      current_user = login create(:user, email: 'admin@test.com', admin: true)
      visit users_path
    end

    scenario "if there is more than 25 records, must have a button to second page" do
      expect_index
      expect(page).to_not have_css('ul.pagination')
      
      create_records_email
      visit users_path
      expect_index
      expect(page).to have_selector(:link_or_button, '2')
      expect(page).to have_css('ul.pagination')
      click_on '2'

      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "26", to: User.all.count.to_s, count: User.all.count) )
    end

    scenario "searching for specific record email must return only it" do
      expect_index

      fill_in :q_email_or_name_cont, with: "user_test28@test.com"
      page.find('#search_button').click
      expect(page).to_not have_content("user_test28@test.com")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.zero') )

      create_records_email
      visit users_path
      expect_index
      fill_in :q_email_or_name_cont, with: "user_test28@test.com"
      page.find('#search_button').click
      expect(page).to have_content("user_test28@test.com")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    end

    scenario "searching for specific record name must return only it" do
      expect_index

      fill_in :q_email_or_name_cont, with: "another28"
      page.find('#search_button').click
      expect(page).to_not have_content("another28")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.zero') )

      create_records_name
      visit users_path
      expect_index
      fill_in :q_email_or_name_cont, with: "another28"
      page.find('#search_button').click
      expect(page).to have_content("another28")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    end
  end
end



# => N O R M A L    U S E R
feature "users views for current user" do
  given!(:user){ create(:user) }

  background :each do
    login user
    visit users_path
  end

  # => I N D E X   A N d    D E S T R O Y
  scenario "listing users" do
    expect(page).to_not have_content( I18n.t('action.index', model: User.model_name.human.pluralize) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    AND   C R E A T E
  scenario "creating a new user" do
    visit new_user_path
    expect(page).to_not have_content( I18n.t('action.new', model: User.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "showing user" do
    visit "/users/#{user.id}"
    expect_show user, user
  end

  # => E D I T    A N D    U P D A T E
  context "updating user" do
    scenario "with valid params" do
      visit "/users/#{user.id}/edit"

      fill_in :user_name, with: "Marco"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated', model: User.model_name.human) )
      expect_show user, user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}/edit"

      fill_in :user_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      user.name = ""
      user.save
      expect_edit user, user
    end
  end

  # => D E S T R O Y    S E S S I O N
  scenario "signing out" do
    expect(page).to have_content( I18n.t('controller.access_denied') )
    click_on I18n.t('link.logout')
    expect(page).to have_content( I18n.t('devise.sessions.signed_out') )
    expect_login
  end
  
  # => U P D A T E    P A S S W O R D
  context "updating user password" do
    scenario "with valid params" do
      visit "/users/#{user.id}"

      expect_show user, user
      click_on I18n.t('link.change_password')
      expect_edit_password user, user

      fill_in :user_current_password, with: "12341234"
      fill_in :user_password, with: "22223333"
      fill_in :user_password_confirmation, with: "22223333"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.password_changed') )
      expect_show user, user
    end

    scenario "with invalid params" do
      visit "/users/#{user.id}"

      click_on I18n.t('link.change_password')
      fill_in :user_current_password, with: "anything"
      fill_in :user_password, with: "12341234"
      fill_in :user_password_confirmation, with: "11112222"
      click_on I18n.t('link.save')

      expect(page).to have_content(I18n.t('errors.messages.invalid'))
      expect(page).to have_content(I18n.t('errors.messages.confirmation', attribute: User.human_attribute_name(:password)))
      expect_edit_password user, user
    end
  end

  # => D E S T R O Y    A C C O U N T
  context "removing user" do
    scenario "with valid email" do
      visit "/users/#{user.id}"

      expect_show user, user
      find('a.btn.btn-danger').click
      expect_destroy_account
      fill_in :user_typed_email, with: user.email
      find('button.btn.btn-danger').click

      expect(page).to have_content( User.human_attribute_name(:destroyed_successfully) )
      expect(page).to_not have_content(user.email)
      expect(page).to_not have_content(user.name)
    end

    scenario "with invalid email" do
      visit "/users/#{user.id}"

      find('a.btn.btn-danger').click
      fill_in :user_typed_email, with: "Anything"
      find('button.btn.btn-danger').click

      expect(page).to have_content( User.human_attribute_name(:invalid_email) )
      expect_show user, user
    end
  end
end



# => A N O T H E R    N O R M A L    U S E R
feature "users views for normal user, trying to access another user profile" do
  given!(:user){ create(:user) }

  background :each do
    login create(:user)
  end
  
  # => I N D E X,  N E W,  C R E A T E,  D E S T R O Y  I S  I N A C C E S S I B L E  F O R  A N Y  N O R M A L  U S E R

  # => S H O W,   U P D A T E   P A S S W O R D   A N D   D E S T R O Y   A C C O U N T
  scenario "showing user" do
    visit "/users/#{user.id}"
    expect(page).to_not have_content(user.name)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "updating user" do
    visit "/users/#{user.id}/edit"
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( User.human_attribute_name(:name) )
  end
end
