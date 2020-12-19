class ItemTag
  include ActiveModel::Model
  attr_accessor :text, :name, :user_id, :item_id, :image, :word

  with_options presence: true do
    validates :name
    validates :image
  end

  validates :name,length: { maximum: 40 }
  validates :text,length: { maximum: 150 } 


  def save
    @item = Item.create(image: image, name: name, text: text, user_id: user_id)
    tag = Tag.where(word: word).first_or_initialize
    tag.save
    ItemTagRelation.create(item_id: @item.id, tag_id: tag.id)
  end
end
