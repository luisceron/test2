require 'rails_helper'

RSpec.describe "transactions/index", type: :view do
  before(:each) do
    assign(:transactions, [
      Transaction.create!(
        :user => nil,
        :account => nil,
        :category => nil,
        :transaction_type => 1,
        :amount => "9.99",
        :description => "Description"
      ),
      Transaction.create!(
        :user => nil,
        :account => nil,
        :category => nil,
        :transaction_type => 1,
        :amount => "9.99",
        :description => "Description"
      )
    ])
  end

  it "renders a list of transactions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
