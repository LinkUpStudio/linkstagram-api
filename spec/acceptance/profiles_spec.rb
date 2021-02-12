require 'acceptance_helper'

resource 'Get profiles' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/profiles' do
    parameter :page, 'Profiles page'

    let!(:profiles) { create_list(:account, 26) }

    example_request 'Get profiles of all users' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(25)
      expect(parsed_json.first['followers']).to be > parsed_json.last['followers']
    end

    context 'when page is defined' do
      let(:page) { 2 }

      example_request 'Get profiles from the concrete page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(1)
      end
    end

    context 'when page is defined', document: true do
      let(:page) { 100 }

      example_request 'returns profiles from the first page' do
        expect(status).to eq(200)
        expect(parsed_json.length).to eq(25)
      end
    end
  end
end
