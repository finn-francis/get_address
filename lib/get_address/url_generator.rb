module GetAddress
  module UrlGenerator
    attr_reader :url

    def generate_url
      url  = "#{GetAddress::BASE_URL}#{postcode}#{house ? "/#{house}" : "" }"
      @url = append_query(url)
    end

    private

    def append_query(url)
      "#{url}?api-key=#{api_key}&format=#{format_array}&sort=#{sort}"
    end
  end
end
