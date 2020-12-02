FactoryBot.define do
  factory :comment do
    text { "text" }
    association :user 
    association :post
    after(:build) do |comment|
      comment.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
