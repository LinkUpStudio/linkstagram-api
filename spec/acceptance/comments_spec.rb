require 'acceptance_helper'

resource 'Comments' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/posts/:post_id/comments', :realistic_error_responses do
    parameter :post_id, 'Post id'
    parameter :page, 'Comments page'

    let!(:post) { create(:post) }
    let!(:user) { create(:account) }
    let!(:comments) { create_list(:comment, 3, post: post, commenter: user) }

    let!(:other_post) do
      create(:post) do |post|
        create_list(:comment, 3, post: post, commenter: user)
      end
    end

    let!(:post_id) { post.id }
    context 'get comments of some post' do
      example_request 'Show comments for all user' do
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
        create_list(:comment, 2, post: post, commenter: user)
      end
      let!(:post_id) { post.id }

      context 'when page is defined', content: false do
        let!(:comments) do
          create_list(:comment, 26, post: post, commenter: user)
        end

        include_examples 'when page is defined'
      end
    end

    context 'failure request', document: false do
      let!(:post_id) { 0 }
      example_request 'returns http status 422' do
        expect(status).to eq(404)
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

      example 'Leave comment only as logged in user' do
        expect { do_request }.to change { Comment.count }.from(0).to(1)
        expect(status).to eq(200)
        created_comment = Comment.first
        expect(created_comment.message).to eq(message)
        expect(created_comment.commenter).to eq(user)
      end
    end

    include_examples 'failures with authentication'

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
