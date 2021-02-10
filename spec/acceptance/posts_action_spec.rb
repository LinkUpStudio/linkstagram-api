require 'acceptance_helper'

include Helpers::JwtToken

resource 'Posts CRUD actions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

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
end
