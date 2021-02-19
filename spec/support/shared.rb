RSpec.shared_examples 'failures with authentication' do
  context 'failures', document: false do
    let(:token) { 'bad_token' }
    example_request 'returns 400' do
      expect(status).to eq(400)
    end
  end
end

RSpec.shared_examples 'failures with authorization' do
  context 'failed requests', document: false do
    let(:token) { parameter }
    example_request 'returns 401' do
      expect(status).to eq(401)
    end
  end
end

RSpec.shared_examples 'failures when invalid username' do
  context 'failures', document: false do
    let!(:username) { parameter }
    example_request 'returns 404' do
      expect(status).to eq(404)
    end
  end
end

RSpec.shared_examples 'when page is defined' do
  context 'when page is defined', document: false do
    let(:page) { 2 }

    example_request 'Get profiles from the concrete page' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(1)
    end
  end
end

RSpec.shared_examples 'when page is invalid' do
  context 'when page is invalid', document: false do
    let(:page) { 100 }

    example_request 'returns profiles from the first page' do
      expect(status).to eq(200)
      expect(parsed_json.length).to eq(2)
    end
  end
end
