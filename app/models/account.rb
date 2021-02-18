# frozen_string_literal: true

class Account < ApplicationRecord
  include ImageUploader::Attachment(:profile_photo)

  has_many :posts, inverse_of: 'author',
                   foreign_key: :author_id,
                   dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, inverse_of: 'commenter',
                      foreign_key: :commenter_id,
                      dependent: :destroy

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { in: 3..20 },
                       format: { with: /[a-zA-Z0-9._-]+/ }

  before_create :set_followers

  scope :ordered, -> { order(followers: :desc) }

  def self.find_by_username(username)
    find_by!('lower(username) = ?', username.downcase.strip)
  end

  def profile_photo_url
    profile_photo.url
  end

  private

  def set_followers
    self.followers = rand(0..1000)
    self.following = rand(0..1000)
  end
end
