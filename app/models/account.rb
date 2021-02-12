# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :posts, inverse_of: 'author',
                   foreign_key: :author_id,
                   dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes,
                         class_name: 'Post',
                         inverse_of: :account,
                         source: 'post'

  validates :username, presence: true,
                       uniqueness: true,
                       length: { in: 3..20 },
                       format: { with: /[a-zA-Z0-9._-]+/ }
  validates :description, presence: false

  before_create :set_followers

  scope :ordered, -> { order(followers: :desc) }

  private

  def set_followers
    self.followers = rand(0..1000)
    self.following = rand(0..1000)
  end
end
