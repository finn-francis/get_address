module GetAddress
  module UrlGenerator
    attr_reader :url

    def generate_url
      @url = "#{GetAddress::BASE_URL}#{postcode}#{house ? "/#{house}" : "" }"
    end
  end
end
