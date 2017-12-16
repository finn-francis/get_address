module GetAddress
  module UrlGenerator
    attr_reader :url

    def generate_url(postcode, house = nil)
      @url = "#{GetAddress::BASE_URL}#{postcode}#{house ? "/#{house}" : "" }"
    end
  end
end
