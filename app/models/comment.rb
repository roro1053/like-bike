class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one_attached :image

  validates :text,length: { maximum: 150 }
  validates :text,presence: true, unless: :was_attached?

  def was_attached?
    self.image.attached?
  end
end
