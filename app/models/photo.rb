class Photo < ApplicationRecord
  belongs_to :post, optional: true

  validates :image_data, presence: true
end
