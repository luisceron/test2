FactoryGirl.define do
  factory :transaction do
    association :user
    association :account
    association :category
    transaction_type :debit
    date "2016-06-28 16:43:00"
    amount "9.99"
    description "Corner Shop"
  end
end
