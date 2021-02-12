require 'acceptance_helper'

resource 'Edit profile' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/account' do
    let(:my_account) { create(:account) }

    context 'get account as logged in user' do
      let(:token) { jwt_token(my_account.id) }

      example_request "Get one's page" do
        expect(status).to eq(200)
        expect(parsed_json).to eq(my_account.as_json)
      end
    end

    context 'get account as logged out user', document: false do
      let(:token) { 'bad_token' }

      example_request 'returns status non authorized' do
        expect(status).to eq(400)
      end
    end
  end

  patch '/account' do
    parameter :username, 'Username'
    parameter :profile_photo, 'User profile photo'
    parameter :description, 'User description'

    let(:username) { 'new_name' }
    let(:profile_photo) { 'new photo' }
    let(:description) { 'new description' }
    let(:my_account) { create(:account) }

    context 'edit own account' do
      let(:token) { jwt_token(my_account.id) }

      example_request "Edit one's account" do
        expect(status).to eq(200)
        my_account.reload
        expect(my_account.username).to eq(username)
        expect(my_account.profile_photo).to eq(profile_photo)
        expect(my_account.description).to eq(description)
      end
    end

    context 'failures', document: false do
      let(:token) { 'bad_token' }

      example 'returns 400 on bad token' do
        prev_attrs = my_account.attributes
        do_request
        expect(my_account.reload.attributes).to eq(prev_attrs)
        expect(status).to eq(400)
      end
    end
  end
end
