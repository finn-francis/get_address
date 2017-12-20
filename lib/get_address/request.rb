require 'get_address/config_methods'
require 'httparty'

module GetAddress
  class Request
    include HTTParty
    include GetAddress::UrlGenerator
    include GetAddress::ConfigMethods

    PERMITTED_VALUES = [:api_key, :format_array, :sort, :postcode, :house].freeze
    REQUIRED_FIELDS  = [:api_key, :format_array, :sort, :postcode].freeze

    attr_reader *PERMITTED_VALUES

    def initialize(options)
      @options = options
      check_for_required_fields
      # TODO raise error if an api_key is not provided(before the request is sent)
      set_options
      generate_url
    end

    def send_request
      HTTParty.get generate_url if valid?
    end

    # validity and error handling
    # TODO maybe turn into a module later?
    def valid?
      errors = []
      add_to_errors(:missing_fields).nil?
    end

    def errors
      @errors ||= []
    end

    def missing_fields
      # TODO Add a message if sort or format_array is missing
      # first tell them to check that they didn't set either of them to nil
      # if the didn't tell them to submit an issue on github
      REQUIRED_FIELDS.each_with_object([]) do |field, list|
        list << field if send(field).nil?
      end
    end

    private
    attr_reader :options
    attr_writer :errors

    def add_to_errors(method, *args)
      result = send(method, *args)
      errors << { method => result } unless result.nil? || result.empty?
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
        instance_variable_set "@#{key}", value
      end
    end
  end
end
