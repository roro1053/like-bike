class ItemTag

  include ActiveModel::Model
  attr_accessor :text, :name, :user_id, :item_id,:image

  with_options presence: true do
    validates :name
  end

  def save
    tag = Tag.create(name: name)
    @item = Item.create(image: image,name: name, text: text, user_id: user_id)
    ItemTagRelation.create( item_id: @item.id, tag_id: tag.id)
  end

end