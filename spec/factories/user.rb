FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@ceron.com"}
    confirmed_at Date.today
  end
end
