class Post < ApplicationRecord
  belongs_to :author, class_name: 'Account'

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos

  scope :ordered, -> { order(created_at: :desc) }

  scope :by_username, ->(username) { Account.find_by_username(username).posts }

  def liked_by?(user)
    !!find_like_by(user)
  end

  def find_like_by(user)
    likes.find_by(account: user)
  end
end
