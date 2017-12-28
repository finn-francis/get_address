require 'get_address/version'
require 'get_address/missing_fields_error'
require 'get_address/configuration'
require 'get_address/url_generator'
require 'get_address/request'
require 'get_address/response'

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

    def find(options)
      GetAddress::Request.new(options).send_request
    end
  end
end
