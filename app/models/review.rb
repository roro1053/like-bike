class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item

  with_options presence: true do
    validates :text
    validates :rating
  end
  validates :text,  length: { maximum: 150 }
end
