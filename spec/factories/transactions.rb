FactoryGirl.define do
  factory :transaction do
    association :user
    association :account
    association :category
    transaction_type :out
    date "28/06/2016"
    amount "9.99"
    description "Corner Shop"
  end
end
