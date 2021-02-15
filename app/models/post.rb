class Post < ApplicationRecord
  belongs_to :author, class_name: 'Account'

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :ordered, -> { order(created_at: :desc) }

  def liked_by?(user)
    !!find_like_by(user)
  end

  def find_like_by(user)
    likes.find_by(account: user)
  end
end
