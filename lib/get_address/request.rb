require 'get_address/config_methods'
require 'get_address/request_validator'
require 'httparty'

module GetAddress
  class Request
    include HTTParty
    include GetAddress::UrlGenerator
    include GetAddress::ConfigMethods
    include GetAddress::RequestValidator

    PERMITTED_VALUES = [:api_key, :format_array, :sort, :postcode, :house].freeze
    REQUIRED_FIELDS  = [:api_key, :format_array, :sort, :postcode].freeze

    attr_reader *PERMITTED_VALUES, :url

    def initialize(options)
      @options = options
      check_for_required_fields
      set_options
      generate_url
    end

    # TODO write spec for this
    def send_request
      if valid?
        HTTParty.get generate_url
      else
        raise GetAddress::MissingFieldsError.new("Missing required fields: #{errors[:missing_fields]}")
      end
    end

    private
    attr_reader :options

    def add_to_errors(method, *args)
      result = send(method, *args)
      errors[method] = result unless result.nil? || result.empty?
    end

    def klass
      self.class
    end

    def check_for_required_fields
      unless options.keys.include?(:postcode)
        raise ArgumentError.new('Missing keyword argument: :postcode')
      end
    end

    def set_options
      { **config_settings, **options }.each do |key, value|
        next unless PERMITTED_VALUES.include?(key)
        # TODO if house is an empty string, set it to nil
        instance_variable_set "@#{key}", value
      end
    end
  end
end
