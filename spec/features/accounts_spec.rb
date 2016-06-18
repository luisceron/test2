require 'rails_helper'

# => V I E W S    C O N T E N T
def expect_index current_user
  expect(page).to have_content( I18n.t('action.index', model: Account.model_name.human.pluralize) )

  expect(page).to have_selector('input#q_name_cont')
  # expect page to have check box All Accounts to search for
  # expect page to have check box Current Accounts to search for
  # expect page to have check box Saving Accounts to search for
  # expect page to have check box Cash Accounts to search for
  expect(page).to have_css('button.btn.btn-sm.btn-primary .fa.fa-search')

  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  expect(page).to have_content( Account.human_attribute_name(:balance) )

  if current_user.accounts.size > 0
    expect(page).to have_content( current_user.accounts.first.name )
    if current_user.accounts.first.account_type == :current_account
      # expect page with badge C (current_account)
      # example   expect(page).to have_css( "div.label.label-success")
    elsif current_user.accounts.first.account_type == :saving_account
      # expect page with badge S (saving_account)
      # example expect(page).to have_css( "div.label.label-success")
    else
      # expect page with badge M (cash_account)
      # example expect(page).to have_css( "div.label.label-success")
    end
    expect(page).to have_content( current_user.accounts.first.balance )
    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")
  end
  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Account.model_name.human) )

  expect(page).to have_content( I18n.t('action.per_page', model: Account.model_name.human.pluralize) )
  expect(page).to have_selector('select#per_page')

  if current_user.account.count == 1
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
  elsif current_user.accounts.count > 25
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "1", to: "25", count: current_user.accounts.count) )
  else    
    expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.other', count: current_user.accounts.count) )
  end
end

def expect_new
  expect(page).to have_content( I18n.t('action.new_fem', model: Account.model_name.human) )
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  # expect to have a select with thre options ( current account, saving account or cash)
  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_selector("input#account_name")
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_selector("input#account_balance")
  expect(page).to have_content( Account.human_attribute_name(:description) )
  expect(page).to have_selector("input#account_description")

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_edit account
  expect(page).to have_content( I18n.t('action.edit', model: Account.model_name.human) )
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  # expect to have a select with choosed option selected( current account, saving account or cash)
  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_field( Account.human_attribute_name(:name), with: account.name )
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_field( Account.human_attribute_name(:balance), with: account.balance )
  expect(page).to have_content( Account.human_attribute_name(:description) )
  expect(page).to have_field( Account.human_attribute_name(:description), with: account.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_show account
  expect(page).to have_content( Account.model_name.human.pluralize )
  expect(page).to have_content( Account.human_attribute_name(:account_type) )
  expect(page).to have_content(account.account_type)
  expect(page).to have_content( Account.human_attribute_name(:name) )
  expect(page).to have_content(account.name)
  expect(page).to have_content( Account.human_attribute_name(:balance) )
  expect(page).to have_content(account.balance)
  expect(page).to have_content( Account.human_attribute_name(:Description) )
  expect(page).to have_content(account.description)
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
end



# => O W N E R    U S E R
feature "accounts views for owner user", type: :feature do
  given!(:account){ create(:account) }

  background :each do
    current_user = login create(:user)
  end

  # => I N D E X
  scenario "listing user accounts" do
    visit user_accounts_path(current_user)
    expect_index current_user
  end

  # => N E W    A N D    C R E A T E
  context "creating a new account" do
    scenario "with valid params" do
      visit new_user_account_path

      expect_new
      select( Account.human_attribute_name(:cash_account), from: Account.human_attribute_name(:account_type) )
      fill_in :account_name, with: "Current Account 1"
      fill_in :account_balance, with: 2500,00
      fill_in :account_description, with: "National Bank Current Account 1"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.created', model: Account.model_name.human) )
      expect_show Account.find_by(name: "Current Account 1")
    end

    scenario "with invalid params" do
      visit new_user_path

      fill_in :account_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      expect_new
    end
  end
  
  # => S H O W
  scenario "showing account" do
    # visit "/accounts/#{account.id}"
    visit account_path(account)
    expect_show account
  end

  # => U P D A T E
  context "updating user" do
    scenario "with valid params" do
      # visit "/accounts/#{account.id}/edit"
      visit account_path(account)

      expect_edit account
      fill_in :account_name, with: "Cash"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated', model: Account.model_name.human) )
      expect_show account
    end

    scenario "with invalid params" do
      # visit "/accounts/#{account.id}/edit"
      visit account_path(account)

      fill_in :account_name, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      account.name = ""
      account.save
      expect_edit account
    end
  end

  # => D E S T R O Y
  scenario "removing account" do
    visit user_accounts_path(current_user)

    expect_index current_user
    first('.btn-danger').click

    expect(page).to have_content( I18n.t('controller.destroyed', model: Account.model_name.human) )
    expect_index current_user
  end

  # => S E A R C H  A N D   P A G I N A T I O N 
  context "searching and pagination" do
    def create_records
      for var in 0..10
        create(:account, account_type: 0) # Current Accounts
      end

      for var in 0..10
        create(:account, account_type: 1) # Saving Accounts
      end

      for var in 0..10
        create(:account, account_type: 2) # Cash Accounts
      end
    end

    background :each do
      current_user = login create(:user)
      visit user_accounts_path(current_user)
    end

    scenario "if there is more than 25 records, must have a button to second page" do
      expect_index current_user
      expect(page).to_not have_css('ul.pagination')
      
      create_records
      visit user_accounts_path(current_user)
      expect_index current_user
      expect(page).to have_selector(:link_or_button, '2')
      expect(page).to have_css('ul.pagination')
      click_on '2'

      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "26", to: current_user.accounts.count.to_s, count: current_user.accounts.count) )
    end

    scenario "searching for specific record name and all types must return only it" do
      expect_index current_user

      fill_in :q_name_cont, with: "Account28"
      page.find('#search_button').click
      expect(page).to_not have_content("Account28")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.zero') )

      create_records
      visit user_accounts_path
      expect_index current_user
      fill_in :q_name_cont, with: "Account28"
      page.find('#search_button').click
      expect(page).to have_content("Account28")
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    end

    scenario "searching for current accounts must return only them" do
      expect_index
      create_records

      # mark current accounts checkboxes
      # can't appear badge for saving account
      # can't appear badge for cash account
    end

    scenario "searching for saving accounts must return only them" do
      expect_index
      create_records

      # mark saving accounts checkboxes
      # can't appear badge for current account
      # can't appear badge for cash account
    end

    scenario "searching for cash accounts must return only them" do
      expect_index
      create_records

      # mark cash accounts checkboxes
      # can't appear badge for current account
      # can't appear badge for saving account
    end
  end
end



# => A D M I N    U S E R
feature "accounts views for admin user", type: :feature do
end



# => A N O T H E R   N O R M A L    U S E R
feature "accounts views for another normal user", type: :feature do
end
