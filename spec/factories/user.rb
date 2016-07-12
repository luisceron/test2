FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@ceron.com"}
    confirmed_at Date.today

    trait :admin do
      admin true
    end

    trait :normal do
      admin false
    end
  end
end
