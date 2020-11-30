class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :text, presence: true, unless: :was_attached?,
                     length: { maximum: 150 }

  def was_attached?
    self.image.attached?
  end
end
