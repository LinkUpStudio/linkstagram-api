require 'acceptance_helper'

resource 'Posts create/read/delete actions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/posts' do
    parameter :page, 'Posts page'

    let!(:posts) { create_list(:post, 2) }

    let(:token) { nil }
    example_request 'Get all posts if user logged out' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(2)
    end

    context 'when user logged in' do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      example_request 'Get all posts if user logged in' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(2)
        expect(parsed_json.first['created_at']).to be > parsed_json.last['created_at']
      end
    end

    context 'pagination' do
      let(:author) { create(:account) }
      let!(:posts) { create_list(:post, 26, author: author) }

      context 'when page is defined' do
        let(:page) { 2 }

        example_request 'Get items from the concrete page' do
          expect(status).to eq(200)
          expect(parsed_json.length).to eq(1)
        end
      end

      context 'when page is out of range', document: false do
        let(:page) { 100 }
        example_request 'returns items from the first page' do
          expect(status).to eq(200)
          expect(parsed_json.length).to eq(25)
        end
      end
    end
  end

  post '/posts' do
    parameter :description, 'Post description'

    let(:author) { create(:account) }
    let(:description) { 'Nice post' }

    context 'successfully created post' do
      let(:token) { jwt_token(author.id) }
      example 'Create post' do
        expect { do_request }.to change { Post.count }.from(0).to(1)
        expect(status).to eq(200)
        created_post = Post.first
        expect(created_post.description).to eq(description)
        expect(created_post.author_id).to eq(author.id)
      end
    end

    context 'failures', document: false do
      let(:token) { nil }
      example_request 'returns http unauthorized' do
        expect(status).to eq(401)
      end
    end
  end

  get '/posts/:id', :realistic_error_responses do
    parameter :id, 'Post id'

    let!(:post) { create(:post) }
    let!(:id) { post.id }
    let(:token) { nil }
    example_request 'Get a post if user logged out' do
      expect(status).to eq(200)
      expect(parsed_json).to eq(post.as_json)
    end

    context 'when user is logged in', document: false do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      example_request 'Get a post if user logged in' do
        expect(status).to eq(200)
        expect(parsed_json).to eq(post.as_json)
      end
    end

    context 'failed requests', document: false do
      let(:id) { 0 }
      example_request 'returns 404 for non existed record' do
        expect(status).to eq(404)
      end
    end
  end

  delete '/posts/:id' do
    parameter :id, 'Post id'

    let!(:posts) { create_list(:post, 5) }
    let!(:id) { posts.first.id }
    let(:token) { jwt_token(posts.first.author_id) }
    example 'Delete post only when the user is the author' do
      expect { do_request }.to change(Post, :count).from(5).to(4)
      expect(status).to eq(200)
    end

    context 'failed requests', document: false do
      let(:token) { jwt_token(posts.last.author_id) }
      example_request 'does not delete post of the other user' do
        expect(status).to eq(401)
      end
    end
  end
end
