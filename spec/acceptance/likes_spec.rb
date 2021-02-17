require 'acceptance_helper'

resource 'Likes' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  post '/posts/:post_id/like', :realistic_error_responses do
    parameter :post_id, 'Post id'

    let!(:user) { create(:account) }
    let!(:post) { create(:post, author: user) }
    let(:post_id) { post.id }
    let(:token) { jwt_token(user.id) }
    context 'creates like as logged in user' do
      example 'Set like' do
        expect { do_request }.to change { Like.count }.from(0).to(1)
        like = Like.first
        expect(like.post).to eq(post)
        expect(like.account).to eq(user)
        expect(status).to eq(200)
      end
    end

    context 'failures creating like', document: false do
      let!(:post_id) { 0 }
      example_request 'returns 404 for non-existed user' do
        expect(status).to eq(404)
      end
    end

    include_examples 'failures with authentication'
  end

  delete '/posts/:post_id/like' do
    parameter :post_id, 'Post id'

    let!(:user) { create(:account) }
    let!(:post) { create(:post, author: user) }
    let!(:post_id) { post.id }
    let!(:like) { create(:like, post: post, account: user) }
    let(:token) { jwt_token(user.id) }
    context 'removes like as logged in user' do
      example 'Remove like' do
        expect { do_request }.to change { Like.count }.from(1).to(0)
        expect(status).to eq(200)
      end
    end

    context 'cannot remove like of the other user', document: false do
      let!(:stranger) { create(:account) }
      let(:token) { jwt_token(stranger.id) }
      example 'Remove like' do
        expect { do_request }.not_to change(Like, :count)
        expect(status).to eq(400)
      end
    end

    include_examples 'failures with authentication'
  end
end
