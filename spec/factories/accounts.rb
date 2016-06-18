FactoryGirl.define do
  factory :account do
    association :user
    account_type 1
    sequence(:name) {|n| "Account#{n}"}
    balance "9.99"
    description "MyString"
  end
end
