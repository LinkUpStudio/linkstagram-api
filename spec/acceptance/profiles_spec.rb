require 'acceptance_helper'

include Helpers::JsonParse

resource 'Get profiles' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/profiles' do
    let!(:profiles) { create_list(:account, 5) }

    example 'Get profile photos for stories' do
      do_request
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(5)
    end
  end
end
