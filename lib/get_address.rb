require 'get_address/version'
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

    def find(options)
      GetAddress::Request.new(options).send
    end
  end
end
