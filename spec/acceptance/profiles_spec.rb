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
      let(:page) { 2 }
      let!(:profiles) { create_list(:account, 26) }

      example_request 'Get profiles from the concrete page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(1)
      end
    end

    context 'when page is invalid', document: false do
      let(:page) { 100 }

      example_request 'returns profiles from the first page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(profiles.size)
      end
    end
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

    context 'failures', document: false do
      let!(:username) { 'bad_request' }
      example_request 'returns 422' do
        expect(status).to eq(422)
      end
    end
  end
end
