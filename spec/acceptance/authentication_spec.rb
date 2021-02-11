require 'acceptance_helper'

resource 'Authentication' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  post '/create-account', 'Add User' do
    parameter :username, 'Username', type: :string, example: 'john_doe', required: true
    parameter :login, 'User email', type: :string, example: 'john_doe@example.com', required: true
    parameter :password, 'User password', type: :string, required: true
    parameter :profile_photo, 'User profile photo', type: :string, required: true

    let(:login) { 'user@example.com' }
    let(:password) { 'password' }
    let(:username) { 'username' }
    let(:profile_photo) { 'photo' }

    example 'Create new account' do
      do_request
      created_user = Account.first
      expect(status).to eq(200)
      expect(created_user.email).to eq(login)
      expect(created_user.username).to eq(username)
      expect(created_user.profile_photo).to eq(profile_photo)
    end

    context 'when incorrect parameters', document: false do
      let(:login) { '' }
      example 'returns status 422' do
        do_request
        expect(status).to eq(422)
      end
    end
  end

  post '/login' do
    parameter :login, 'User email', type: :string, example: 'john_doe@example.com', required: true
    parameter :password, 'User password', type: :string, required: true
    explanation "After 'Log in' you can get user's JWT. Loging out means just deleting this token."

    let!(:account) { create(:account, password: 'password') }

    let(:login) { account.email }
    let(:password) { 'password' }
    example 'Log in as registered user' do
      do_request
      expect(status).to eq(200)
    end

    context 'when password incorrect', document: false do
      let(:password) { 'incorrect' }
      example 'returns status 401' do
        do_request
        expect(status).to eq(401)
      end
    end

    context 'when user is not registered', document: false do
      let(:login) { 'non-existed-user' }
      example 'returns status 401' do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end
