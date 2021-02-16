require 'acceptance_helper'

resource 'Get profiles' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/profiles' do
    parameter :page, 'Profiles page'

    let!(:profiles) { create_list(:account, 2) }

    example_request 'Get profiles of all users' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(profiles.size)
      expect(parsed_json.first['followers']).to be > parsed_json.last['followers']
    end

    context 'when page is defined', content: false do
      let!(:profiles) { create_list(:account, 26) }

      include_examples 'when page is defined'
    end

    include_examples 'when page is invalid'
  end

  get '/profiles/:username' do
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
