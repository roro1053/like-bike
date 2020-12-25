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
end
