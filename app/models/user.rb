class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :likes,dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :following_relationships,foreign_key: "follower_id", class_name: "FollowRelationship",  dependent: :destroy
  has_many :followings, through: :following_relationships
  has_many :follower_relationships,foreign_key: "following_id",class_name: "FollowRelationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  validates :nickname, presence: true,
                       length: { maximum: 40 }
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze },
                       length: { minimum: 6 },
                       presence: true, on: :create
  validates :profile,  length: { maximum: 150 }

  def self.guest
    find_or_create_by(email: 'test@com', nickname: 'guest') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  #すでにフォロー済みであればture返す
  def following?(other_user)
    self.followings.include?(other_user)
  end

  #ユーザーをフォローする
  def follow(other_user)
    self.following_relationships.create(following_id: other_user.id)
  end

  #ユーザーのフォローを解除する
  def unfollow(other_user)
    self.following_relationships.find_by(following_id: other_user.id).destroy
  end
end
