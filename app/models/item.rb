class Item < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :item_tag_relations
  has_many :tags, through: :item_tag_relations, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  with_options presence: true do
    validates :name
    validates :image
  end

  validates :name,length: { maximum: 40 }
  validates :text,length: { maximum: 150 } 

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

  def save_tags(saveitem_tags)
    current_tags = self.tags.pluck(:word) unless self.tags.nil?
    old_tags = current_tags - saveitem_tags
    new_tags = saveitem_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(word: old_name)
    end

    new_tags.each do |new_name|
      item_tag = Tag.find_or_create_by(word: new_name)
      self.tags << item_tag
    end
  end
end
