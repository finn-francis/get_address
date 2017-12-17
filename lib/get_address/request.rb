require 'get_address/config_methods'

module GetAddress
  class Request
    include GetAddress::UrlGenerator
    include GetAddress::ConfigMethods

    PERMITTED_VALUES = [:api_key, :format_array, :sort, :postcode, :house].freeze

    attr_reader *PERMITTED_VALUES

    def initialize(options)
      @options = options
      check_for_required_fields
      # TODO raise error if an api_key is not provided(before the request is sent)
      set_options
      generate_url
    end

    private
    attr_reader :options

    def check_for_required_fields
      unless options.keys.include?(:postcode)
        raise ArgumentError.new('Missing keyword argument: :postcode')
      end
    end

    def set_options
      { **config_settings, **options }.each do |key, value|
        next unless PERMITTED_VALUES.include?(key)
        instance_variable_set "@#{key}", value
      end
    end
  end
end
