FactoryGirl.define do
  factory :category do
    association :user
    sequence(:name) {|n| "Category#{n}"}
    description "Category Description"
  end
end
