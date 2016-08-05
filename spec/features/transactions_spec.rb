require 'rails_helper'

# => V I E W S    C O N T E N T
def expect_transaction_index transactions
  expect(page).to have_selector(:link_or_button, Transaction.model_name.human(count: 2) )
  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Transaction.model_name.human) )

# MONTHLY
  # expect(page).to have_css("td.text-center.in-background",  text: number_to_currency(transactions.scope_in.sum(:amount)))
  # expect(page).to have_css("td.text-center.out-background", text: number_to_currency(transactions.scope_out.sum(:amount)))
  # expect(page).to have_css("td.tex-center", text: Transaction.human_attribute_name(:total))
  # total_transactions = transactions.scope_in.sum(:amount) - transactions.scope_out.sum(:amount)
  # if total_transactions < 0
  #   expect(page).to have_css("td.right-cell.out-background", text: number_to_currency(total_transactions))
  # else
  #   expect(page).to have_css("td.right-cell.in-background", text: number_to_currency(total_transactions))
  # end

# TOTAL



  expect(page).to have_selector('select#q_by_year')
  expect(page).to have_selector('select#q_by_month')
  expect(page).to have_selector('select#q_account_id_eq')
  expect(page).to have_css('button.btn.btn-default .fa.fa-search')
  
  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_content( I18n.t(:in, scope: "activerecord.attributes.transaction.transaction_types") )
  expect(page).to have_content( I18n.t(:out, scope: "activerecord.attributes.transaction.transaction_types") )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )

  if transactions.size == 1
    first_transaction = transactions.first
    expect(page).to have_content( first_transaction.account )
    expect(page).to have_content( first_transaction.category )
    expect(page).to have_content( first_transaction.date.strftime("%d/%m/%Y") )
    if first_transaction.transaction_type.to_sym == :in
      expect(page).to have_css("td.in-color", text: number_to_currency(first_transaction.amount))
    elsif first_transaction.transaction_type.to_sym == :out
      expect(page).to have_css("td.out-color", text: number_to_currency(first_transaction.amount))
    end
    expect(page).to have_content( first_transaction.description )
    expect(page).to have_css("a.btn.btn-xs.btn-primary .fa.fa-pencil-square-o")
    expect(page).to have_css("a.btn.btn-xs.btn-danger .fa.fa-trash")
  end
end

def expect_transaction_new
  expect(page).to have_selector(:link_or_button, Transaction.model_name.human(count: 2) )
  expect(page).to have_selector(:link_or_button, I18n.t('action.new_fem', model: Transaction.model_name.human) )
  
  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_selector("select#transaction_account_id")
  ########## Would be test the options ########################################################
  #                                                                                           #
  #############################################################################################

  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_selector("select#transaction_category_id")
  ########## Do a loop get all the categories and check options################################
  #                                                                                           #
  #############################################################################################

  expect(page).to have_content( Transaction.human_attribute_name(:transaction_type) )
  expect(page).to have_selector("select#transaction_transaction_type")
  ########## Transaction types options ########################################################
  #                                                                                           #
  #############################################################################################

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
  expect(page).to have_selector(:link_or_button, Transaction.model_name.human(count: 2) )
  expect(page).to have_selector(:link_or_button, I18n.t('action.edit', model: Transaction.model_name.human) )

  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_select(  Transaction.human_attribute_name(:account), selected: transaction.account.name )
  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_select(  Transaction.human_attribute_name(:category), selected: transaction.category.name )
  expect(page).to have_content( Transaction.human_attribute_name(:transaction_type) )
  expect(page).to have_select(  Transaction.human_attribute_name(:transaction_type), selected: I18n.t(transaction.transaction_type.to_sym, scope: "activerecord.attributes.transaction.transaction_types") )
  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_field(   Transaction.human_attribute_name(:date), with: transaction.date )
  expect(page).to have_content( Transaction.human_attribute_name(:amount) )
  expect(page).to have_field(   Transaction.human_attribute_name(:amount), with: transaction.amount.to_s )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_field(   Transaction.human_attribute_name(:description), with: transaction.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.save') )
  expect(page).to have_css("button.btn.btn-primary .fa.fa-save")
end

def expect_transaction_show transaction
  expect(page).to have_selector(:link_or_button, Transaction.model_name.human(count: 2) )
  expect(page).to have_selector(:link_or_button, transaction )

  expect(page).to have_content( Transaction.human_attribute_name(:account) )
  expect(page).to have_content( transaction.account )
  expect(page).to have_content( Transaction.human_attribute_name(:category) )
  expect(page).to have_content( transaction.category )
  expect(page).to have_content( Transaction.human_attribute_name(:transaction_type) )
  expect(page).to have_content( I18n.t(transaction.transaction_type.to_sym, scope: "activerecord.attributes.transaction.transaction_types") )
  expect(page).to have_content( Transaction.human_attribute_name(:date) )
  expect(page).to have_content( transaction.date.strftime("%d/%m/%Y") )
  expect(page).to have_content( Transaction.human_attribute_name(:amount) )
  expect(page).to have_content( number_to_currency transaction.amount )
  expect(page).to have_content( Transaction.human_attribute_name(:description) )
  expect(page).to have_content( transaction.description )

  expect(page).to have_selector(:link_or_button, I18n.t('link.back') )
  expect(page).to have_selector(:link_or_button, I18n.t('link.edit') )
end



# => O W N E R    U S E R
feature "transactions views for owner user", type: :feature do
  given!(:current_user){ create(:user)                            }
  given!(:transaction) { create(:transaction, user: current_user) }
  given!(:account)     { create(:account,     user: current_user, name: "Bank of Ireland") }
  given!(:category)    { create(:category,    user: current_user, name: "Car") }

  background :each do
    login current_user
  end

  # => I N D E X
  scenario "listing user transactions" do
    visit user_transactions_path(current_user)
    expect_transaction_index current_user.transactions
  end

  # => N E W    A N D    C R E A T E
  context "creating a new transaction" do
    scenario "with valid params" do
      visit new_user_transaction_path(current_user)
      expect_transaction_new

      select account.name,                          from: :transaction_account_id
      select category.name,                         from: :transaction_category_id
      select I18n.t(:in, scope: "activerecord.attributes.transaction.transaction_types"), from: Transaction.human_attribute_name(:transaction_type)
      fill_in :transaction_date,                    with: Date.today
      fill_in :transaction_amount,                  with: 200.00
      fill_in :transaction_description,             with: "Car Wash"
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.created_fem', model: Transaction.model_name.human) )
      expect_transaction_index current_user.transactions
    end

    scenario "with invalid params" do
      visit new_user_transaction_path(current_user)

      fill_in :transaction_date, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      expect_transaction_new
    end
  end
  
  # => S H O W
  scenario "showing transaction" do
    visit transaction_path(transaction)
    expect_transaction_show transaction
  end

  # => E D I T    A N D   U P D A T E
  context "updating transaction" do
    scenario "with valid params" do
      visit edit_transaction_path(transaction)

      expect_transaction_edit transaction

      fill_in :transaction_amount, with: 250.00
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('controller.updated_fem', model: Transaction.model_name.human) )
      expect_transaction_index current_user.transactions
    end

    scenario "with invalid params" do
      visit edit_transaction_path(transaction)

      fill_in :transaction_amount, with: ""
      click_on I18n.t('link.save')

      expect(page).to have_content( I18n.t('errors.messages.blank') )
      transaction.amount = ""
      transaction.save
      expect_transaction_edit transaction
    end
  end

  # => D E S T R O Y
  scenario "removing transaction" do
    visit user_transactions_path(current_user)

    expect_transaction_index current_user.transactions
    first('.btn-danger').click

    expect(page).to have_content( I18n.t('controller.destroyed_fem', model: Transaction.model_name.human) )
    expect_transaction_index current_user.transactions
  end

  # => S E A R C H    A N D   P A G I N A T I O N 
  context "searching and pagination" do      
    let!(:account2) { create(:account,  user: current_user, name: "Bank of England") }
    let!(:account3) { create(:account,  user: current_user, name: "Bank of America") }
    let!(:category2){ create(:category, user: current_user, name: "Shopping") }
    let!(:category3){ create(:category, user: current_user, name: "Home") }

    def create_records
      for var in 0..5
        create(:transaction, description: "Description#{var}", user: current_user, account: account, category: category, transaction_type: :out, date: "01/01/2015")
      end

      for var in 6..10
        create(:transaction, description: "Description#{var}", user: current_user, account: account, category: category, transaction_type: :out, date: Date.today)
      end

      for var in 11..15
        create(:transaction, description: "Description#{var}", user: current_user, account: account2, category: category2, transaction_type: :in, date: "02/02/2016")
      end

      for var in 16..20
        create(:transaction, description: "Description#{var}", user: current_user, account: account2, category: category2, transaction_type: :in, date: Date.today)
      end

      for var in 21..25
        create(:transaction, description: "Description#{var}", user: current_user, account: account3, category: category3, transaction_type: :out, date: "03/02/2016")
      end

      for var in 26..30
        create(:transaction, description: "Description#{var}", user: current_user, account: account3, category: category3, transaction_type: :out, date: Date.today)
      end
    end

    background :each do
      login current_user
      visit user_transactions_path(current_user)
    end

    scenario "when searching by an account must return only them" do
      expect_transaction_index current_user.transactions

      create_records
      visit user_transactions_path(current_user)
      expect_transaction_index current_user.transactions.current_month_scope

      select account.name, from: :q_account_id_eq
      click_on I18n.t('action.search')
      expect(page).to_not have_content("Description5")
      expect(page).to     have_content("Description6")
      expect(page).to_not have_content("Description11")
      expect(page).to_not have_content("Description16")
      expect(page).to_not have_content("Description21")
      expect(page).to_not have_content("Description26")

      select account2.name, from: :q_account_id_eq
      click_on I18n.t('action.search')
      expect(page).to_not have_content("Description5")
      expect(page).to_not have_content("Description6")
      expect(page).to_not have_content("Description11")
      expect(page).to     have_content("Description16")
      expect(page).to_not have_content("Description21")
      expect(page).to_not have_content("Description26")

      select account3.name, from: :q_account_id_eq
      click_on I18n.t('action.search')
      expect(page).to_not have_content("Description5")
      expect(page).to_not have_content("Description6")
      expect(page).to_not have_content("Description11")
      expect(page).to_not have_content("Description16")
      expect(page).to_not have_content("Description21")
      expect(page).to     have_content("Description26")
    end

    scenario "when searching by an year and month must return only them" do
      expect_transaction_index current_user.transactions

      create_records
      visit user_transactions_path(current_user)
      expect_transaction_index current_user.transactions.current_month_scope

      select 2016, from: :q_by_year
      click_on I18n.t('action.search')
      expect(page).to_not have_content("Description5")
      expect(page).to     have_content("Description6")
      expect(page).to_not have_content("Description11")
      expect(page).to     have_content("Description16")
      expect(page).to_not have_content("Description21")
      expect(page).to     have_content("Description26")

      select I18n.t('date.month_names').third, from: :q_by_month

      click_on I18n.t('action.search')
      expect(page).to_not have_content("Description5")
      expect(page).to_not have_content("Description6")
      expect(page).to     have_content("Description11")
      expect(page).to_not have_content("Description16")
      expect(page).to     have_content("Description21")
      expect(page).to_not have_content("Description26")
    end
  end
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
