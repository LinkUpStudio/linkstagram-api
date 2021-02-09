# frozen_string_literal: true

class Account < ApplicationRecord
  # has_many :posts

  validates :username, presence: true,
                       uniqueness: true,
                       length: { in: 3..20 },
                       format: { with: /[a-zA-Z0-9._-]+/ }
  validates :description, presence: false
  validates :profile_photo, presence: true
end
