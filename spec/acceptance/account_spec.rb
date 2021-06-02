require 'acceptance_helper'

resource 'Edit profile' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :token

  get '/account' do
    let(:my_account) { create(:account, :with_photo) }

    context 'get account as logged in user' do
      let(:token) { jwt_token(my_account.id) }

      example_request 'Get account' do
        expect(status).to eq(200)
         response_body
        expect(response_body).to eq(AccountBlueprint.render(my_account, view: :private))
      end
    end

    context 'get account as logged out user', document: false do
      include_examples 'failures with authentication'
    end
  end

  patch '/account' do
    with_options scope: :account do
      parameter :username, 'Username'
      parameter :profile_photo, 'User profile photo'
      parameter :description, 'User description'
      parameter :first_name, 'User first name'
      parameter :last_name, 'User last name'
      parameter :job_title, 'User job title'
    end

    let(:username) { 'new_name' }
    let(:profile_photo) { Helpers::TestData.image_data }
    let(:description) { 'new description' }
    let(:first_name) { 'new first name' }
    let(:last_name) { 'new last name' }
    let(:job_title) { 'new job title' }
    let(:my_account) { create(:account) }

    context 'edit own account' do
      let(:token) { jwt_token(my_account.id) }

      example_request 'Edit account' do
        expect(status).to eq(200)
        my_account.reload
        expect(my_account.username).to eq(username)
        expect(my_account.profile_photo_data['storage']).to eq('store')
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
