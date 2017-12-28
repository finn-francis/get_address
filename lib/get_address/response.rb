require 'get_address/config_methods'

module GetAddress
  class Response
    include GetAddress::ConfigMethods

    attr_reader :httparty_response, :status, :request, :raw_body

    def initialize(request, httparty_response)
      @httparty_response = httparty_response
      @status            = httparty_response.code
      @request           = request
      @raw_body          = httparty_response.body
    end

    def body
      {
        latitude:  parsed_response['latitude'],
        longitude: parsed_response['longitude'],
        addresses: map_addresses
      }
    end

    private

    def parsed_response
      httparty_response.parsed_response
    end

    def map_addresses
      addresses = parsed_response['addresses']

      addresses.map do |address|
        lines = address.split(', ')

        config.raw_keymap.each_with_object({}) do |line, hash|
          hash[line[0]] = lines[line[1]]
        end
      end
    end
  end
end
