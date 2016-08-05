require 'rails_helper'

# => V I E W S    C O N T E N T
def expect_account_index current_user
  expect(page).to have_content( Account.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.index', model: Account.model_name.human(count: 2)) )
  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_content( Account.human_attribute_name(:balance) )

  if current_user.accounts.size > 0
    expect(page).to have_content( current_user.accounts.first.name )

    if current_user.accounts.first.account_type.to_sym == :current_account
      expect(page).to have_css( "div.label.label-success" )
      expect(page.find("div.label.label-success" ).text).to eq( Account.human_attribute_name(:current_letter) )
    elsif current_user.accounts.first.account_type.to_sym == :saving_account
      expect(page).to have_css( "div.label.label-primary" )
      expect(page.find("div.label.label-primary" ).text).to eq( Account.human_attribute_name(:saving_letter) )
    elsif current_user.accounts.first.account_type.to_sym == :cash_account
      expect(page).to have_css( "div.label.label-default" )
      expect(page.find("div.label.label-default" ).text).to eq( Account.human_attribute_name(:cash_letter) )
    end

    expect(page).to have_content( number_to_currency current_user.accounts.first.balance )
    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")

    expect(page).to have_content( I18n.t('action.per_page', model: Account.model_name.human(count: 2)) )
    expect(page).to have_selector('select#per_page')
  
    if current_user.accounts.count == 1
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    elsif current_user.accounts.count > 25
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "1", to: "25", count: current_user.accounts.count) )
    else    
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.other', count: current_user.accounts.count) )
    end
  end

  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Account.model_name.human) )
end

def expect_account_new
  expect(page).to have_content( Account.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.new_fem', model: Account.model_name.human) )
  
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  expect(page).to have_selector("select#account_account_type")
  expect(find("option[value=current_account]").text).to eq( I18n.t(:current_account, scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=saving_account]").text).to  eq( I18n.t(:saving_account, scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=cash_account]").text).to    eq( I18n.t(:cash_account, scope: "activerecord.attributes.account.account_types"))

  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_selector("input#account_name")
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_selector("input#account_balance")
  expect(page).to have_content( Account.human_attribute_name(:description) )
  expect(page).to have_selector("textarea#account_description")

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_account_edit account
  expect(page).to have_content( Account.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.edit', model: Account.model_name.human) )

  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  expect(page).to have_selector("select#account_account_type")
  expect(find("option[value=current_account]").text).to eq( I18n.t(:current_account, scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=saving_account]").text).to  eq( I18n.t(:saving_account, scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=cash_account]").text).to    eq( I18n.t(:cash_account, scope: "activerecord.attributes.account.account_types"))  

  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_field(   Account.human_attribute_name(:name), with: account.name )
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_content( account.balance )
  expect(page).to have_content( Account.human_attribute_name(:description) )
  expect(page).to have_field(   Account.human_attribute_name(:description), with: account.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_account_show account
  expect(page).to have_content( Account.model_name.human(count: 2) )
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  expect(page).to have_content( I18n.t(account.account_type.to_sym, scope: "activerecord.attributes.account.account_types") )
  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_content( account.name )
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_content( number_to_currency account.balance )
  expect(page).to have_content( Account.human_attribute_name(:description) )
  expect(page).to have_content( account.description )
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
end



# => O W N E R    U S E R
feature "accounts views for owner user", type: :feature do
  given!(:current_user){ create(:user) }
  given!(:account){ create(:account, user: current_user) }

  background :each do
    login current_user
  end

  # => I N D E X
  scenario "listing user accounts" do
    visit user_accounts_path(current_user)
    expect_account_index current_user
  end

  # => N E W    A N D    C R E A T E
  context "creating a new account" do
    scenario "with valid params" do
      visit new_user_account_path(current_user)

      expect_account_new
      select( I18n.t(:cash_account, scope: "activerecord.attributes.account.account_types"), from: Account.human_attribute_name(:account_type) )
      fill_in :account_name, with: "Cash"
      fill_in :account_balance, with: 2500.00
      fill_in :account_description, with: "Cash Account"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.created_fem', model: Account.model_name.human) )
      expect_account_show Account.find_by(name: "Cash")
    end

    scenario "with invalid params" do
      visit new_user_account_path(current_user)

      fill_in :account_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      expect_account_new
    end
  end
  
  # => S H O W
  scenario "showing account" do
    visit account_path(account)
    expect_account_show account
  end

  # => E D I T    A N D   U P D A T E
  context "updating user" do
    scenario "with valid params" do
      visit edit_account_path(account)

      expect_account_edit account
      fill_in :account_name, with: "Cash"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated_fem', model: Account.model_name.human) )
      account.name = "Cash"
      account.save
      expect_account_show account
    end

    scenario "with invalid params" do
      visit edit_account_path(account)

      fill_in :account_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      account.name = ""
      account.save
      expect_account_edit account
    end
  end

  # => D E S T R O Y
  scenario "removing account" do
    visit user_accounts_path(current_user)

    expect_account_index current_user
    first('.btn-danger').click

    expect(page).to have_content( I18n.t('controller.destroyed_fem', model: Account.model_name.human) )
    expect_account_index current_user
  end

  # => S E A R C H  A N D   P A G I N A T I O N 
  context "searching and pagination" do
    let!(:current_user) { create(:user) }

    def reset_database current_user
      current_user.accounts.destroy_all
    end

    def create_records
      for var in 0..10
        create(:account, account_type: :current_account, user: current_user) # Current Accounts
      end

      for var in 0..10
        create(:account, account_type: :saving_account, user: current_user) # Saving Accounts
      end

      for var in 0..10
        create(:account, account_type: :cash_account, user: current_user) # Cash Accounts
      end
    end

    background :each do
      reset_database current_user
      login current_user
      visit user_accounts_path(current_user)
    end

    scenario "if there is more than 25 records, must have a button to second page" do
      expect_account_index current_user
      expect(page).to_not have_css('ul.pagination')

      create_records
      visit user_accounts_path(current_user)
      expect_account_index current_user
      expect(page).to have_selector(:link_or_button, '2')
      expect(page).to have_css('ul.pagination')
      click_on '2'

      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "26", to: current_user.accounts.count.to_s, count: current_user.accounts.count) )
    end
  end
end



# => A D M I N    U S E R
feature "another user accounts views for admin user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:account){ create(:account, user: user_owner) }

  background :each do
    current_user = login create(:user, admin: true)
    visit user_accounts_path(user_owner)
  end

  # => I N D E X   A N d    D E S T R O Y
  scenario "can't list accounts" do
    expect(page).to_not have_content( I18n.t('action.index', model: Account.model_name.human(count: 2)) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    AND   C R E A T E
  scenario "can't create a new account" do
    visit new_user_account_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new', model: Account.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an account" do
    visit account_path(account)
    expect(page).to_not have_content(account.name)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't update an account" do
    visit edit_account_path(account)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Account.human_attribute_name(:name) )
  end
end



# => A N O T H E R   N O R M A L    U S E R
feature "a user accounts views for another normal user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:account){ create(:account, user: user_owner) }

  background :each do
    current_user = login create(:user)
    visit user_accounts_path(user_owner)
  end

  # => I N D E X   A N D    D E S T R O Y
  scenario "can't list accounts" do
    expect(page).to_not have_content( I18n.t('action.index', model: Account.model_name.human(count: 2)) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    A N D   C R E A T E
  scenario "can't create a new account" do
    visit new_user_account_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new', model: Account.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an account" do
    visit account_path(account)
    expect(page).to_not have_content(account.name)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't update an account" do
    visit edit_account_path(account)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Account.human_attribute_name(:name) )
  end
end
