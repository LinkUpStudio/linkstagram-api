class User < ApplicationRecord
  belongs_to :account

  validates :login, presence: true,
                    uniqueness: true,
                    length: { in: 3..20 },
                    format: { with: /[a-zA-Z0-9._.-]+/ }
  validates :description, allow_blank: true
  validates :profile_photo, allow_blank: false
end
