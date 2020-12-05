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
  
  validates :nickname, presence: true,
                       length: { maximum: 40 }
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze },
                       length: { minimum: 6 }
  validates :profile,  length: { maximum: 150 }
end
