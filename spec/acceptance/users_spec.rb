require 'acceptance_helper'

resource 'Users' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  route '/create-account', 'Add User' do
    attribute :username, 'Username', type: :string, example: 'john_doe', required: true
    attribute :email, 'User email', type: :string, example: 'john_doe@example.com', required: true
    attribute :password, 'User password', type: :string, required: true
    attribute :profile_photo, 'User profile photo', type: :string, required: true
    # parameter :description, 'User description', type: :text, required: false

    post 'Create user' do
      let(:email) { 'user@example.com' }
      let(:password) { 'password' }
      let(:username) { 'username' }
      let(:profile_photo) { 'photo' }

      xcontext 'when success' do
        let(:request) { { password: password, email: email, login: username, profile_photo: profile_photo } }
        example 'returns status 200' do
          do_request(request)
          p response_body
          r = Rodauth::Rails.rodauth
          p r.login_meets_requirements?(email)
          expect(status).to eq(200)
        end
      end

      context 'when incorrect parameters' do
        let(:request) { { password: password, login: nil, profile_photo: nil } }
        example 'returns status 400' do
          # 400 or 422
          do_request(request)
          expect(status).to eq(422)
        end
      end
    end
  end

  route '/login', 'Log in as registered user' do
    attribute :username, 'Username', type: :string, example: 'john_doe', required: true
    attribute :password, 'User password', type: :string, required: true

    post 'Log in' do
      let!(:account) { create(:account) }

      context 'when success' do
        let(:request) { { password: 'password', login: account.username } }
        example 'returns status 200' do
          do_request(request)
          expect(status).to eq(200)
        end
      end

      context 'when password incorrect' do
        let(:request) { { password: 'incorrect', login: account.username } }
        example 'returns status 401' do
          do_request(request)
          expect(status).to eq(401)
        end
      end

      context 'when user is not registered' do
        let(:request) { { password: 'password', login: 'non-existed-user' } }
        example 'returns status 401' do
          do_request(request)
          expect(status).to eq(401)
        end
      end
    end
  end

  route '/logout', 'Log out' do
    post 'Log out' do
      context 'when success' do
        let!(:account) { create(:account) }
        example 'returns status 200' do
          rodauth = Rodauth::Rails.rodauth
          token = JWT.encode({ account_id: account.id }, rodauth.jwt_secret, rodauth.jwt_algorithm)
          header 'HTTP_AUTHORIZATION', "Bearer #{token}"
          do_request
          expect(status).to eq(200)
        end
      end
    end
  end
end
