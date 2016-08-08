FactoryGirl.define do
  factory :account do
    association :user
    account_type :cash_account
    sequence(:name) {|n| "Account#{n}"}
    balance 100.00
    description "MyString"
  end
end
