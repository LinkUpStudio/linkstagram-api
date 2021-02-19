require 'acceptance_helper'

resource 'Posts create/read/delete actions' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/posts' do
    parameter :page, 'Posts page'

    let!(:posts) { create_list(:post, 2) }

    let(:token) { nil }
    example_request 'Get all posts' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(2)
    end

    context 'when user logged in', document: false do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      example_request 'Get all posts if user logged in' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(2)
      end
    end

    context 'pagination' do
      let(:author) { create(:account) }

      context 'when page is defined' do
        let!(:posts) { create_list(:post, 26, author: author) }
        include_examples 'when page is defined'
      end

      include_examples 'when page is invalid'
    end
  end

  get '/profiles/:username/posts', :realistic_error_responses do
    parameter :username, 'Profile username'

    let!(:user) { create(:account) }
    let!(:user_posts) { create_list(:post, 2, author: user) }

    context 'success' do
      let!(:other_user) do
        create(:account) do |user|
          create(:post, author: user)
        end
      end

      let!(:username) { user.username }
      example_request 'Get posts of single user' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(user_posts.size)
      end
    end

    context 'failures' do
      it_behaves_like 'failures when invalid username' do
        let(:parameter) { 'bad_username' }
      end
    end

    context 'failures', document: false do
      let!(:boring_user) { create(:account, username: 'boring') }
      let!(:username) { boring_user.username }
      example_request 'returns empty array' do
        expect(status).to eq(200)
        expect(boring_user.posts.size).to eq(0)
      end
    end
  end

  post '/posts' do
    with_options scope: :post do
      parameter :description, 'Post description'
      parameter :photos_attributes, 'Photos'
    end

    let(:author) { create(:account) }
    let!(:photos_attributes) { [{ image: Helpers::TestData.image_data }] }
    let(:description) { 'Nice post' }

    context 'successfully created post' do
      let(:token) { jwt_token(author.id) }
      example 'Create post' do
        expect { do_request }.to change { Post.count }.from(0).to(1)
        expect(status).to eq(200)
        created_post = Post.first
        expect(created_post.description).to eq(description)
        expect(created_post.author_id).to eq(author.id)
        expect(created_post.photos.size).to eq(photos_attributes.size)
      end
    end

    context 'failures' do
      it_behaves_like 'failures with authorization' do
        let(:parameter) { nil }
      end
    end
  end

  get '/posts/:id', :realistic_error_responses do
    parameter :id, 'Post id'

    let!(:post) { create(:post) }
    let!(:id) { post.id }
    let(:token) { nil }
    example_request 'Get a post' do
      expect(status).to eq(200)
      expect(response_body).to eq(PostBlueprint.render(post))
    end

    context 'when user is logged in', document: false do
      let(:user) { create(:account) }
      let(:token) { jwt_token(user.id) }
      let!(:like) { create(:like, post: post, account: user) }
      example_request 'Get a post if user logged in' do
        expect(status).to eq(200)
        expect(response_body).to eq(PostBlueprint.render(post, user: user))
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

    let!(:photo) { create(:photo, post: posts.first) }
    example 'Delete photo along with post', document: false do
      expect { do_request }.to change(Photo, :count).from(1).to(0)
      expect(status).to eq(200)
    end

    context 'failures' do
      it_behaves_like 'failures with authorization' do
        let(:parameter) { jwt_token(posts.last.author_id) }
      end
    end
  end
end
