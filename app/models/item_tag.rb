class ItemTag
  include ActiveModel::Model
  attr_accessor :text, :name, :user_id, :item_id, :image, :word

  with_options presence: true do
    validates :name
    validates :image
    # validates :word
  end

  with_options length: { maximum: 150 } do
    validates :name
    validates :text
  end

  def save
    @item = Item.create(image: image, name: name, text: text, user_id: user_id)
    tag = Tag.where(word: word).first_or_initialize
    tag.save
    ItemTagRelation.create(item_id: @item.id, tag_id: tag.id)
  end
end
