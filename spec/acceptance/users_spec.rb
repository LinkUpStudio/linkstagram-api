require 'acceptance_helper'

resource 'Users' do
  header 'Accept', 'application/json'
  header "Content-Type", "application/json"

  route '/create-account', 'Add User' do
    attribute :login, 'User login', type: :string, example: 'john_doe', required: true
    attribute :email, 'User email', type: :string, example: 'john_doe@example.com', required: true
    attribute :password, 'User password', type: :string, required: true
    attribute :profile_photo, 'User profile photo', type: :string, required: true
    # parameter :description, 'User description', type: :text, required: false

    post 'Create user' do
      # let!(:raw_post) { params.to_json }
      let(:email) { 'user@example.com' }
      let(:password) { 'password' }
      let(:login) { 'login' }
      let(:profile_photo) { 'photo' }
      let(:request) { { email: email, password: password, login: login, profile_photo: profile_photo } }

      context 'when success' do
        example 'returns status 200' do
          do_request(request)
          p response_body, request
          rodauth = Rodauth::Rails.rodauth
          p rodauth.login_meets_requirements?(request[:email])
          expect(status).to eq(200)
        end
      end
    end
  end
end
