require 'bundler/setup'
require 'simplecov'
require 'webmock/rspec'
require 'get_address'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    response_body   = "{\"latitude\":51.064519,\"longitude\":-0.328801,\"addresses\":[\"Johnstone Kemp Tooley Ltd, Solo House, The Courtyard, London Road, , Horsham, West Sussex\",\"Smith Gadd & Co, 1-2 The Courtyard, London Road, , , Horsham, West Sussex\",\"Sovereign Credit Management, 3 The Courtyard, London Road, , , Horsham, West Sussex\",\"The Courtyard Surgery, The Courtyard, London Road, , , Horsham, West Sussex\"]}"
    parsed_response = JSON.parse response_body

    stub_request(:get, "https://api.getaddress.io/find/FOO?api-key=MY_API_KEY&format=true&sort=false").to_return(status: 200, body: response_body, headers: {})

    # TODO this is a nasty hack and needs to be changed ASAP
    allow_any_instance_of(HTTParty::Response).to receive(:parsed_response).and_return(parsed_response)
  end
end
