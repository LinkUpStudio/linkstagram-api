class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :account, class_name: 'Account'

  scope :ordered, -> { order(created_at: :desc) }
end