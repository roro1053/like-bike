class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :tags

  with_options presence: true do
    validates :name
    validates :image
  end
  with_options length: { maximum: 150 } do
    validates :name
    validates :text
  end
end
