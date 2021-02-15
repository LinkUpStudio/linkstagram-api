require 'acceptance_helper'

resource 'Comments' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/posts/:post_id/comments' do
    parameter :post_id, 'Post id'
    parameter :page, 'Comments page'

    let!(:post) { create(:post) }
    let!(:user) { create(:account) }
    let!(:comments) { create_list(:comment, 3, post: post, commenter: user) }

    let!(:post_id) { post.id }
    context 'get comments of some post' do
      example_request 'Show comments for logged out user' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(comments.size)
      end
    end

    context 'get comments of some post', document: false do
      let(:token) { jwt_token(user.id) }
      example_request 'Get comments for logged in user' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(comments.size)
      end
    end

    context 'pagination', document: false do
      let!(:comments) do
        create_list(:comment, 26, post: post, commenter: user)
      end
      let!(:page) { 2 }
      let!(:post_id) { post.id }

      example_request 'get comments from the concrete page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(1)
      end
    end
  end

  post '/posts/:post_id/comments', :realistic_error_responses do
    parameter :message, 'Comment message'
    parameter :post_id, 'Post id'

    let!(:post) { create(:post) }
    let!(:user) { create(:account) }

    let!(:post_id) { post.id }
    let!(:message) { 'my first comment' }

    context 'successfully created comment' do
      let!(:token) { jwt_token(user.id) }

      example 'Create comment for logged in user' do
        expect { do_request }.to change { Comment.count }.from(0).to(1)
        expect(status).to eq(200)
        created_comment = Comment.first
        expect(created_comment.message).to eq(message)
        expect(created_comment.commenter).to eq(user)
      end
    end

    context 'failures with authorization', document: false do
      let!(:token) { 'bad_token' }
      example_request 'does not create comment for logged out user' do
        expect(status).to eq(400)
      end
    end

    context 'failures with post id', document: false do
      let!(:token) { jwt_token(user.id) }
      let!(:post_id) { 0 }
      example_request 'return status 422' do
        expect(status).to eq(422)
      end
    end

    context 'failures with message', document: false do
      let!(:token) { jwt_token(user.id) }
      let!(:post_id) { post.id }
      let!(:message) { '' }
      example_request 'return status 422' do
        expect(status).to eq(422)
      end
    end
  end
end