require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      :user => nil,
      :account => nil,
      :category => nil,
      :transaction_type => 1,
      :amount => "9.99",
      :description => "MyString"
    ))
  end

  it "renders the edit transaction form" do
    render

    assert_select "form[action=?][method=?]", transaction_path(@transaction), "post" do

      assert_select "input#transaction_user_id[name=?]", "transaction[user_id]"

      assert_select "input#transaction_account_id[name=?]", "transaction[account_id]"

      assert_select "input#transaction_category_id[name=?]", "transaction[category_id]"

      assert_select "input#transaction_transaction_type[name=?]", "transaction[transaction_type]"

      assert_select "input#transaction_amount[name=?]", "transaction[amount]"

      assert_select "input#transaction_description[name=?]", "transaction[description]"
    end
  end
end
