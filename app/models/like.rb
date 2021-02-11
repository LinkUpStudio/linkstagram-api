class Like < ApplicationRecord
  belongs_to :account, inverse_of: :likes
  belongs_to :post, dependent: :destroy, inverse_of: :likes

  validates_uniqueness_of :post_id, scope: [:account_id]
end
