require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '.create' do
    let(:post) { create(:post) }
    let(:account) { create(:account) }
    let!(:like) { create(:like, account: account, post: post) }
    it 'does not create second like for the same post' do
      second_like = build(:like, account: account, post: post)
      expect(second_like).to_not be_valid
    end
  end
end
