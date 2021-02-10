require 'acceptance_helper'

include Helpers::JwtToken

resource 'Edit profile' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  patch '/account' do
    parameter :username, 'Username'
    parameter :profile_photo, 'User profile photo'
    parameter :description, 'User description'

    let(:username) { 'new_name' }
    let(:profile_photo) { 'new photo' }
    let(:description) { 'new description' }

    context 'edit own account' do
      let(:my_account) { create(:account) }
      let(:token) { jwt_token(my_account.id) }
      example 'Edit user profile' do
        do_request
        expect(status).to eq(200)
        my_account.reload
        expect(my_account.username).to eq(username)
        expect(my_account.profile_photo).to eq(profile_photo)
        expect(my_account.description).to eq(description)
      end
    end

    context 'edit account of the other user' do
      let(:token) { nil }
      example 'Edit user profile' do
        do_request
        expect(status).to eq(401)
      end
    end
  end
end
