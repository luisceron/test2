require 'rails_helper'

# => O W N E R    U S E R
feature "transactions views for owner user", type: :feature do
  given!(:current_user){ create(:user) }
  given!(:transaction){ create(:transaction, user: current_user) }

  background :each do
    login current_user
  end

  # => I N D E X
  # scenario "listing user transactions", js: true do
  #   visit user_transactions_path(current_user)
  #   expect_transaction_index current_user
  # end

  # # => N E W    A N D    C R E A T E
  # context "creating a new transaction" do
  #   scenario "with valid params" do
  #     visit new_user_transaction_path(current_user)

  #     expect_transaction_new
  #     fill_in :transaction_name, with: "Entertainment"
  #     click_on I18n.t('link.save')

  #     expect(page).to have_content( I18n.t('controller.created_fem', model: Transaction.model_name.human) )
  #     expect_transaction_show Transaction.find_by(name: "Entertainment")
  #   end

  #   scenario "with invalid params" do
  #     visit new_user_transaction_path(current_user)

  #     fill_in :transaction_name, with: ""
  #     click_on I18n.t('link.save')

  #     expect(page).to have_content( I18n.t('errors.messages.blank') )
  #     expect_transaction_new
  #   end
  # end
  
  # # => S H O W
  # scenario "showing transaction" do
  #   visit transaction_path(transaction)
  #   expect_transaction_show transaction
  # end

  # # => E D I T    A N D   U P D A T E
  # context "updating transaction" do
  #   scenario "with valid params" do
  #     visit edit_transaction_path(transaction)

  #     expect_transaction_edit transaction
  #     fill_in :transaction_name, with: "Car"
  #     click_on I18n.t('link.save')

  #     expect(page).to have_content( I18n.t('controller.updated_fem', model: Transaction.model_name.human) )
  #     transaction.name = "Car"
  #     transaction.save
  #     expect_transaction_show transaction
  #   end

  #   scenario "with invalid params" do
  #     visit edit_transaction_path(transaction)

  #     fill_in :transaction_name, with: ""
  #     click_on I18n.t('link.save')

  #     expect(page).to have_content( I18n.t('errors.messages.blank') )
  #     transaction.name = ""
  #     transaction.save
  #     expect_transaction_edit transaction
  #   end
  # end

  # # => D E S T R O Y
  # scenario "removing transaction" do
  #   visit user_transactions_path(current_user)

  #   expect_transaction_index current_user
  #   first('.btn-danger').click

  #   expect(page).to have_content( I18n.t('controller.destroyed_fem', model: Transaction.model_name.human) )
  #   expect_transaction_index current_user
  # end

  # # => P A G I N A T I O N 
  # context "pagination" do
  #   let!(:current_user) { create(:user) }

  #   def create_records
  #     for var in 0..30
  #       create(:transaction, name: "name#{var}", user: current_user)
  #     end
  #   end

  #   background :each do
  #     login current_user
  #     visit user_transactions_path(current_user)
  #   end

  #   scenario "if there is more than 25 records, must have a button to second page" do
  #     expect_transaction_index current_user
  #     expect(page).to_not have_css('ul.pagination')

  #     create_records
  #     visit user_transactions_path(current_user)
  #     expect_transaction_index current_user
  #     expect(page).to have_selector(:link_or_button, '2')
  #     expect(page).to have_css('ul.pagination')
  #     click_on '2'

  #     expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "26", to: current_user.transactions.count, count: current_user.transactions.count) )
  #   end
  # end
end



# => A D M I N    U S E R
feature "another user transactions views for admin user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:transaction){ create(:transaction, user: user_owner) }

  background :each do
    current_user = login create(:user, admin: true)
    visit user_transactions_path(user_owner)
  end

  # => I N D E X   A N d    D E S T R O Y
  scenario "can't list transactions" do
    expect(page).to_not have_content( I18n.t('action.index', model: Transaction.model_name.human(count: 2)) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    AND   C R E A T E
  scenario "can't access to create a new transaction" do
    visit new_user_transaction_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new_fem', model: Transaction.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an transaction" do
    visit transaction_path(transaction)
    expect(page).to_not have_content(transaction.amount)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't access to update an transaction" do
    visit edit_transaction_path(transaction)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Transaction.human_attribute_name(:amount) )
  end
end



# => A N O T H E R   N O R M A L    U S E R
feature "a user transactions views for another normal user", type: :feature do
  given!(:user_owner) { create(:user) }
  given!(:transaction){ create(:transaction, user: user_owner) }

  background :each do
    current_user = login create(:user)
    visit user_transactions_path(user_owner)
  end

  # => I N D E X   A N D    D E S T R O Y
  scenario "can't list transactions" do
    expect(page).to_not have_content( I18n.t('action.index', model: Transaction.model_name.human(count: 2)) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => N E W    A N D   C R E A T E
  scenario "can't access to create a new transaction" do
    visit new_user_transaction_path(user_owner)
    expect(page).to_not have_content( I18n.t('action.new_fem', model: Transaction.model_name.human) )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end
  
  # => S H O W
  scenario "can't show an transaction" do
    visit transaction_path(transaction)
    expect(page).to_not have_content(transaction.amount)
    expect(page).to_not have_content( I18n.t('link.edit') )
    expect(page).to have_content( I18n.t('controller.access_denied') )
  end

  # => E D I T    A N D   U P D A T E
  scenario "can't acess to update an transaction" do
    visit edit_transaction_path(transaction)
    expect(page).to have_content( I18n.t('controller.access_denied') )
    expect(page).to_not have_field( Transaction.human_attribute_name(:amount) )
  end
end



# => V I E W S    C O N T E N T
def expect_transaction_index current_user
  expect(page).to have_content( Transaction.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.index', model: Transaction.model_name.human(count: 2)) )

  expect(page).to have_selector('input#description_cont')
  # expect page to search for Account
  # expect page to search for Category
  # expect page to search for Date
  # expect page to search for Transaction Type
  expect(page).to have_css('button.btn.btn-sm.btn-primary .fa.fa-search')

  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_content( Transaction.human_attribute_name(:amount) )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )

  if current_user.transactions.size > 0
    expect(page).to have_content( current_user.transactions.first.account )
    # expect page to have badge for type (C: credit / D: Debit)
    expect(page).to have_content( current_user.transactions.first.category )
    expect(page).to have_content( current_user.transactions.first.date )
    expect(page).to have_content( current_user.transactions.first.amount )
    expect(page).to have_content( current_user.transactions.first.description )

    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")

    expect(page).to have_content( I18n.t('action.per_page', model: Transaction.model_name.human(count: 2)) )
    expect(page).to have_selector('select#per_page')
  
    if current_user.transactions.count == 1
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.one') )
    elsif current_user.transactions.count > 25
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.multi_page', from: "1", to: "25", count: current_user.transactions.count) )
    else    
      expect(page).to have_content( I18n.t('will_paginate.page_entries_info.single_page_html.other', count: current_user.transactions.count) )
    end
  end

  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Transaction.model_name.human) )
end

def expect_transaction_new
  expect(page).to have_content( Transaction.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.new_fem', model: Transaction.model_name.human) )
  
  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_selector("select#transaction_account")
  expect(find("option[value=current_account]").text).to eq( I18n.t(:current_account, scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=saving_account]").text).to  eq( I18n.t(:saving_account,  scope: "activerecord.attributes.account.account_types") )
  expect(find("option[value=cash_account]").text).to    eq( I18n.t(:cash_account,    scope: "activerecord.attributes.account.account_types") )

  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_selector("select#transaction_category")
  # Do a loop get all the categories and check options

  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_selector("input#transaction_date")

  expect(page).to have_content( Transaction.human_attribute_name(:amount) )
  expect(page).to have_selector("input#transaction_amount")

  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_selector("input#transaction_description")

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_transaction_edit transaction
  expect(page).to have_content( Transaction.model_name.human(count: 2) )
  expect(page).to have_content( I18n.t('action.edit', model: Transaction.model_name.human) )

  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_selector("select#transaction_account")
  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_selector("select#transaction_category")
  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_selector("input#transaction_date")
  expect(page).to have_content( Transaction.human_attribute_name(:amount) )
  expect(page).to have_selector("input#transaction_amount")
  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_selector("input#transaction_description")

  expect(page).to have_content( Transaction.human_attribute_name(:name) )
  expect(page).to have_field( Transaction.human_attribute_name(:name), with: transaction.name )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_field( Transaction.human_attribute_name(:description), with: transaction.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_transaction_show transaction
  expect(page).to have_content( Transaction.model_name.human(count: 2) )
  expect(page).to have_content( Transaction.human_attribute_name(:name) )
  expect(page).to have_content( transaction.name )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_content( transaction.description )
  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
end
