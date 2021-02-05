# frozen_string_literal: true

class Account < ApplicationRecord
  has_one :user

  # has_many :posts
end
