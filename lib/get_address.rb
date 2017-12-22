require 'get_address/version'
require 'get_address/missing_fields_error'
require 'get_address/configuration'
require 'get_address/url_generator'
require 'get_address/request'

module GetAddress
  BASE_URL = 'https://api.getAddress.io/find/'

  class << self
    def configure
      @@config = Configuration.new.tap { |config| yield config }
    end

    def config
      @@config
    end
    # def configuration
    alias_method :configuration, :config

    # TODO create the response class and return that instead
    def find(options)
      request           = GetAddress::Request.new(options)
      httparty_response = request.send_request
      {request: request, httparty_response: httparty_response}
    end
  end
end
