class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :item_tag_relations
  has_many :tags, through: :item_tag_relations
  has_many :reviews, dependent: :destroy

  def avg_score
    unless self.reviews.empty?
      reviews.average(:rating).round(1).to_f
    else
    0.0
    end
  end
  def review_score_percentage
    unless self.reviews.empty?
      reviews.average(:rating).round(1).to_f*100/5
    end
  end

  def self.locate(locate)
    if locate != ""
      Item.where('text LIKE(?)', "%#{locate}%")
      Item.where('name LIKE(?)', "%#{locate}%")
      Item.joins(:tags).where("word LIKE (?)", "%#{locate}%").uniq
    else
      Item.all
    end
  end
end
