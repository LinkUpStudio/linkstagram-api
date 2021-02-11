require 'acceptance_helper'

include Helpers::JsonParse

resource 'Get profiles' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/profiles' do
    parameter :page, 'Profiles page'

    let!(:profiles) { create_list(:account, 26) }

    example_request 'Get profiles of all users' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(25)
      sorted_profiles = profiles.sort_by { |profile| profile['followers'] }
      expect(parsed_json).to match_array(sorted_profiles[1..25].as_json)
    end

    context 'when page is defined' do
      let(:page) { 2 }

      example_request 'Get profiles from the concrete page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(1)
      end
    end
  end
end
