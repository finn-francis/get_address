RSpec.describe GetAddress do
  extend SetupConfiguration

  shared_examples 'configuration' do
    it 'should return the get_address configuration' do
      expect(config.api_key).to eq 'MY_API_KEY'
      expect(config.format_array).to be true
      expect(config.sort).to be false
    end
  end

  it 'has a version number' do
    expect(GetAddress::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'should allow configuration options to be set' do
      expect(configure).to be_truthy
    end
  end

  describe '#config' do
    let(:config) do
      configure
      GetAddress.config
    end
    it_behaves_like 'configuration'

    describe '#configuration(alias)' do
      let(:config) do
        configure
        GetAddress.configuration
      end
      it_behaves_like 'configuration'
    end

    describe 'defaults' do
      let(:configure) { GetAddress.configure { |config| config.api_key = 'MY_API_KEY' } }

      it 'should set defaults if no arguments are provided' do
        expect(config.api_key).to eq 'MY_API_KEY'
        expect(config.format_array).to be false
        expect(config.sort).to be true
      end
    end
  end

  describe 'BASE_URL' do
    it 'should return the getaddress.io url' do
      expect(GetAddress::BASE_URL).to eq 'https://api.getAddress.io/find/'
    end
  end

  # TODO test this properly when the response class is done
  describe '#find' do
    let(:do_request) { GetAddress.find(postcode: 'FOO') }
    before { configure }

    it 'should send a request' do
      expect(do_request[:request]).to be_a GetAddress::Request
    end
  end
end
