require 'get_address/config_methods'
require 'httparty'

module GetAddress
  class Request
    include HTTParty
    include GetAddress::UrlGenerator
    include GetAddress::ConfigMethods

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

    # validity and error handling
    # TODO maybe turn into a module later?
    def valid?
      self.errors = {}
      add_to_errors(:missing_fields).nil?
    end

    def errors
      @errors ||= {}
    end

    def missing_fields
      # TODO Add a message if sort or format_array is missing
      # first tell them to check that they didn't set either of them to nil
      # if the didn't tell them to submit an issue on github
      REQUIRED_FIELDS.select { |field| send(field).nil? }
    end

    private
    attr_reader :options
    attr_writer :errors

    def add_to_errors(method, *args)
      result = send(method, *args)
      errors[method] = result unless result.nil? || result.empty?
    end

    # TODO turn this into a module later?
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
