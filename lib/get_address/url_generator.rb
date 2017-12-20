module GetAddress
  module UrlGenerator
    attr_reader :url

    def generate_url
      @url = "#{GetAddress::BASE_URL}#{postcode}#{house ? "/#{house}" : "" }?api-key=#{api_key}"
    end
  end
end
