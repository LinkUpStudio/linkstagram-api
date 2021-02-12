require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '.create' do
    it 'is valid with valid attributes' do
      expect(build(:account, :with_description)).to be_valid
    end

    it 'is valid without description' do
      expect(build(:account)).to be_valid
    end

    it 'is invalid without login' do
      expect(build(:account, username: nil)).not_to be_valid
    end

    it 'is invalid with invalid login' do
      expect(build(:account, username: '*!@#$%')).not_to be_valid
      expect(build(:account, username: 'ab')).not_to be_valid
      expect(build(:account, username: Array('a'..'z').join)).not_to be_valid
    end

    it 'is invalid without profile photo' do
      expect(build(:account, profile_photo: nil)).to be_valid
    end
  end
end
