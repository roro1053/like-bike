class ItemTag

  include ActiveModel::Model
  attr_accessor  :name

  with_options presence: true do
    validates :name
  end

  def save
    tag = Tag.create(name: name)

    TweetTagRelation.create( item_id: item.id, tag_id: tag.id)
  end

end