class Post < ApplicationRecord
  belongs_to :account

  has_many :likes, dependent: :destroy, inverse_of: :post
end
