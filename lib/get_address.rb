require "get_address/version"
require 'get_address/request'

module GetAddress
  BASE_URL = "https://api.getAddress.io/find/"

  class << self
    def configure
      @@config = Configuration.new.tap { |config| yield config }
    end

    def config
      @@config
    end
    # def configuration
    alias_method :configuration, :config
  end
end
