require 'acceptance_helper'

resource 'Profiles' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/profiles' do
    parameter :page, 'Profiles page'
    parameter :per_page, 'Profiles per page'

    context 'successful request' do
      let!(:popular_user) { create(:account, followers: 900) }
      let!(:boring_user) { create(:account, followers: 50) }

      example_request 'Get profiles of all users' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(Account.count)
        expect(parsed_json.first['followers']).to be > parsed_json.last['followers']
      end

      include_examples 'when page is invalid'
    end

    context 'when page and per_page defined', content: false do
      let!(:profiles) { create_list(:account, 26) }

      include_examples 'when page and per_page defined'
    end
  end

  get '/profiles/:username', :realistic_error_responses do
    parameter :username, 'Profile username'

    context 'success' do
      let!(:user) { create(:account) }
      let!(:username) { user.username }
      example_request 'Get profile' do
        expect(status).to eq(200)
        expect(response_body).to eq(AccountBlueprint.render(user))
      end
    end

    context 'failures' do
      it_behaves_like 'failures when invalid username' do
        let(:parameter) { 'bad_username' }
      end
    end
  end
end
