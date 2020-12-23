FactoryBot.define do
  factory :item do
    name { Faker::Name.initials }
    text { Faker::Name.initials }
   
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
