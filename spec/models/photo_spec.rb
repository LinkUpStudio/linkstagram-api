require 'rails_helper'

RSpec.describe Photo, type: :model do
  describe '.create' do
    it 'is valid with valid attributes' do
      expect(build(:photo)).to be_valid
    end

    it 'is valid without post id' do
      expect(build(:photo, post: nil)).not_to be_valid
    end

    it 'is invalid without image data' do
      expect(build(:photo, image_data: nil)).to_not be_valid
    end
  end
end
