FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@ceron.com"}
    name {"User #{email}"}
    password "web12345"
    password_confirmation "web12345"
    confirmed_at Date.today
  end
end
