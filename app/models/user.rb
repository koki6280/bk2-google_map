class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  attachment :profile_image, destroy: false

  include JpPrefecture

  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  # バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: { maximum: 20, minimum: 2 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
end
