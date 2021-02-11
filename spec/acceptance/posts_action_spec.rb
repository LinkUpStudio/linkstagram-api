require 'acceptance_helper'

include Helpers::JwtToken
include Helpers::JsonParse

resource 'Posts CRUD actions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/posts' do
    let!(:posts) { create_list(:post, 6) }

    let(:token) { nil }
    example 'Get all posts if user logged out' do
      do_request
      expect(status).to eq(200)
      expect(parsed_json.size).to eq(posts.size)
    end

    context do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      example 'Get all posts if user logged in' do
        do_request
        expect(status).to eq(200)
        expect(parsed_json.size).to eq(posts.size)
      end
    end
  end

  post '/posts' do
    parameter :description, 'Post description'
    parameter :account_id, 'Account id of the author of post'

    let(:author) { create(:account) }
    let(:description) { 'Nice post' }
    let(:account_id) { author.id }

    context 'successfully created post' do
      let(:token) { jwt_token(author.id) }
      example 'Create post' do
        do_request
        expect(status).to eq(200)
        created_post = Post.first
        expect(created_post.description).to eq(description)
        expect(created_post.account_id).to eq(account_id)
      end
    end

    context 'cannot create post' do
      let(:token) { jwt_token(author.id) }
      let(:account_id) { nil }
      example "doesn't create with invalid params", document: false do
        do_request
        expect(status).to eq(400)
      end
    end

    context 'cannot create post' do
      let(:token) { nil }
      example 'returns http unauthorized', document: false do
        do_request
        expect(status).to eq(401)
      end
    end
  end

  get '/posts/:id', :realistic_error_responses do
    parameter :id, 'Post id'

    let!(:post) { create(:post) }
    let!(:id) { post.id }
    let(:token) { nil }
    example 'Get a post if user logged out' do
      do_request
      expect(status).to eq(200)
      expect(parsed_json).to eq(post.as_json)
    end

    context do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      example 'Get a post if user logged in' do
        do_request
        expect(status).to eq(200)
        expect(parsed_json).to eq(post.as_json)
      end
    end

    context 'failed requests', document: false do
      let(:id) { 0 }
      example 'returns 404 for non existed record' do
        do_request
        expect(status).to eq(404)
      end
    end
  end

  delete '/posts/:id' do
    parameter :id, 'Post id'

    let!(:posts) { create_list(:post, 5) }
    let!(:id) { posts.first.id }
    let(:token) { jwt_token(posts.first.account_id) }
    example 'Delete post only when the user is the author' do
      do_request
      expect(status).to eq(200)
      expect(Post.count).to eq(4)
    end

    context 'failed requests', document: false do
      let(:token) { jwt_token(posts.last.account_id) }
      example 'does not delete post of the other user' do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end
