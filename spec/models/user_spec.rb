# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.new' do
    it 'is valid with valid attributes' do
      expect(build(:user)).to be_valid
    end

    it 'is valid without description' do
      expect(build(:user, description: nil)).to be_valid
    end

    it 'is invalid without login' do
      expect(build(:user, login: nil)).not_to be_valid
    end

    it 'is invalid with invalid login' do
      expect(build(:user, login: '*!@#$%')).not_to be_valid
      expect(build(:user, login: 'ab')).not_to be_valid
      expect(build(:user, login: Array('a'..'z').join)).not_to be_valid
    end

    it 'is invalid without profile photo' do
      expect(build(:user, profile_photo: nil)).not_to be_valid
    end

  end
end
