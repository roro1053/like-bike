class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :text, length: { maximum: 150 }
  validates :text, presence: true, unless: :was_attached?

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  def was_attached?
    image.attached?
  end

  def self.search(search)
    if search != ''
      Post.where('text LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end
end
