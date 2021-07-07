class Photo < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :post, optional: true

  validates :image_data, presence: true

  def url
    image&.url
  end
end
