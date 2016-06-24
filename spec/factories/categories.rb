FactoryGirl.define do
  factory :category do
    association :user
    name "Market"
    description "Market Shopping"
  end
end
