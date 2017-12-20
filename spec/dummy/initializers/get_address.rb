# This file is used to require the get_address gem and setup your configurations
require 'get_address'

GetAddress.configure do |config|
  # NEVER add your api key directly to this file
  # For this example we are using the dotenv gem
  # In the dummy repository there is a file called .env.example
  # Remove the .example extension and add your api keys and any other environment variables to this file
  config.api_key      = ENV['GET_ADDRESS_API_KEY']
  config.format_array = false
  config.sort         = true
end
