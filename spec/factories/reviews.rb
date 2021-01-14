FactoryBot.define do
  factory :review do
    rating { 1 }
    text { 'text' }
    association :user
    association :item
  end
end
