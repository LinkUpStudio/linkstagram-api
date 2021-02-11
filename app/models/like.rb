class Like < ApplicationRecord
  belongs_to :account, inverse_of: :likes
  belongs_to :post, dependent: :destroy, inverse_of: :likes
end
