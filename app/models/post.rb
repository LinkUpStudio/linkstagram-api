class Post < ApplicationRecord
  belongs_to :author, class_name: 'Account'

  has_many :likes, dependent: :destroy, inverse_of: :post
end
