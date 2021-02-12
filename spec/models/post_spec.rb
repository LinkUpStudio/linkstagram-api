require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#liked_by?' do
    let(:post) { create(:post) }
    let(:user) { create(:account) }
    let(:other_user) { create(:account) }
    let!(:like) { create(:like, account: user, post: post) }
    it 'returns true if user has liked post' do
      expect(post.liked_by?(user)).to eq(true)
      expect(post.liked_by?(other_user)).to eq(false)
    end
  end

  describe '#find_like_by' do
    let(:post) { create(:post) }
    let(:user) { create(:account) }
    let(:other_user) { create(:account) }
    let!(:like) { create(:like, account: user, post: post) }
    it 'returns true if user has liked post' do
      expect(post.find_like_by(user)).to eq(like)
      expect(post.find_like_by(other_user)).to eq(nil)
    end
  end
end
