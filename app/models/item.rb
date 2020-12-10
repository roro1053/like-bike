class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :item_tag_relations
  has_many :tags, through: :item_tag_relations, dependent: :destroy
  has_many :reviews, dependent: :destroy

  def avg_score
    if reviews.empty?
      0.0
    else
      reviews.average(:rating).round(1).to_f
    end
  end

  def review_score_percentage
    reviews.average(:rating).round(1).to_f * 100 / 5 unless reviews.empty?
  end

  def self.locate(locate)
    if locate != ''
      Item.joins(:tags).where('text LIKE(?) OR name LIKE(?) OR word LIKE(?)', "%#{locate}%", "%#{locate}%", "%#{locate}%")
    else
      Item.all
    end
  end
end
