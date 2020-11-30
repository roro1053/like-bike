class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :text,length: { maximum: 150 }
  validates :text,presence: true, unless: :was_attached?
 

  def was_attached?
    self.image.attached?
  end

  def self.search(search)
    if search != ""
      Post.where('text LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end
end
