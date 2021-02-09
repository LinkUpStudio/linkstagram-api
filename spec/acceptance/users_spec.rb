require 'acceptance_helper'

resource 'Users' do
  header 'Accept', 'application/json'
  header "Content-Type", "application/json"

  route '/create-account', 'Add User' do
    attribute :login, 'User login', type: :string, example: 'john_doe', required: true
    attribute :email, 'User email', type: :string, example: 'john_doe@example.com', required: true # email or login
    attribute :password, 'User password', type: :string, required: true
    attribute :profile_photo, 'User profile photo', type: :string, required: true
    # parameter :description, 'User description', type: :text, required: false

    post 'Create user' do
      # let!(:raw_post) { params.to_json }
      # let(:email) { 'user@example.com' }
      let(:password) { 'password' }
      let(:login) { 'user@example.com' }
      let(:profile_photo) { 'photo' }
      let(:request) { { password: password, login: login, profile_photo: profile_photo } }

      context 'when success' do
        example 'returns status 200' do
          p request
          do_request(request)
          p response_body
          expect(status).to eq(200)
        end
      end
    end
  end
end
