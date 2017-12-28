require 'spec_helper'

RSpec.describe GetAddress::Response do
  extend SetupConfiguration

  let(:request) { GetAddress::Request.new(options) }
  let(:options) { { postcode: 'FOO' } }
  # TODO move this somewhere else
  let(:expected_addresses) do
    [
      {
        line_1: "Johnstone Kemp Tooley Ltd",
        line_2: "Solo House",
        line_3: "The Courtyard",
        line_4: "London Road",
        locality: "",
        town: "Horsham",
        country: "West Sussex"
      },
     {
       line_1: "Smith Gadd & Co",
       line_2: "1-2 The Courtyard",
       line_3: "London Road",
       line_4: "",
       locality: "",
       town: "Horsham",
       country: "West Sussex"
     },
     {
       line_1: "Sovereign Credit Management",
       line_2: "3 The Courtyard",
       line_3: "London Road",
       line_4: "",
       locality: "",
       town: "Horsham",
       country: "West Sussex"
     },
     {
       line_1: "The Courtyard Surgery",
       line_2: "The Courtyard",
       line_3: "London Road",
       line_4: "",
       locality: "",
       town: "Horsham",
       country: "West Sussex"
     }
   ]
  end

  before { configure }
  before { config }

  let(:response) { request.send_request }

  it 'should require a HTTParty response' do
    expect { GetAddress::Response.new }.to raise_error ArgumentError
  end

  context 'from a successfull HTTParty request' do
    let(:response_body) { "{\"latitude\":51.064519,\"longitude\":-0.328801,\"addresses\":[\"Johnstone Kemp Tooley Ltd, Solo House, The Courtyard, London Road, , Horsham, West Sussex\",\"Smith Gadd & Co, 1-2 The Courtyard, London Road, , , Horsham, West Sussex\",\"Sovereign Credit Management, 3 The Courtyard, London Road, , , Horsham, West Sussex\",\"The Courtyard Surgery, The Courtyard, London Road, , , Horsham, West Sussex\"]}" }
    let(:parsed_response) { JSON.parse response_body }

    before do
      # TODO move this somewhere
      stub_request(:get, "https://api.getaddress.io/find/FOO?api-key=MY_API_KEY&format=true&sort=false").
       to_return(status: 200, body: response_body, headers: {})

      # TODO this is a nasty hack and needs to be changed ASAP
      allow_any_instance_of(HTTParty::Response).to receive(:parsed_response).and_return(parsed_response)
    end

    it 'should set a status code' do
      expect(response.status).to eq 200
    end

    it 'should have a getter for the GetAddress::Request' do
      expect(response.request).to eq request
    end

    describe '#map_addresses' do
      it 'should return the addresses keymapped' do
        expect(response.send(:map_addresses)).to eq expected_addresses
      end
    end

    describe '#body' do
      it 'should return the body with the addressed keymapped' do
        expect(response.body).to eq ({latitude: 51.064519, longitude: -0.328801, addresses: expected_addresses})
      end
    end

    describe '#raw_body' do
      it 'should return the raw body' do
        expect(response.raw_body).to eq response_body
      end
    end

    describe '#parsed_response' do
      it 'should return the HTTParty parsed response' do
        expect(response.send(:parsed_response)).to eq(response.httparty_response.parsed_response)
      end
    end
  end
end
