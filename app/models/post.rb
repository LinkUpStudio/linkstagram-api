class Post < ApplicationRecord
  belongs_to :account

  has_many :likes, inverse_of: :post
end
