module GetAddress
  class Request
    include GetAddress::UrlGenerator

    PERMITTED_VALUES = [:api_key, :format_array, :sort, :postcode, :house].freeze

    attr_reader *PERMITTED_VALUES

    def initialize(options = {})
      # TODO raise error if a postcode is not provided
      # TODO raise error if an api_key is not provided(before the request is sent)
      set_options(options)
      generate_url(postcode, house)
    end

    private

    def config
      GetAddress.config
    end

    def set_options(options)
      { **config_settings, **options }.each do |key, value|
        next unless PERMITTED_VALUES.include?(key)
        instance_variable_set "@#{key}", value
      end
    end

    def config_settings
      config.settings
    end
  end
end
