# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :posts

  validates :username, presence: true,
                       uniqueness: true,
                       length: { in: 3..20 },
                       format: { with: /[a-zA-Z0-9._-]+/ }
  validates :description, presence: false
  validates :profile_photo, presence: true

  before_create :set_followers

  private

  def set_followers
    self.followers = rand(0..1000)
    self.following = rand(0..1000)
  end
end
