class Post < ApplicationRecord
  belongs_to :author, class_name: 'Account'

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :photos, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :with_photos, -> { includes(:photos) }
  scope :with_authors, -> { includes(:author) }

  def liked_by?(user)
    !!find_like_by(user)
  end

  def find_like_by(user)
    likes.find_by(account: user)
  end
end
