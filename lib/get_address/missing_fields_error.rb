module GetAddress
  class MissingFieldsError < StandardError
    DEFAULTS = [:sort, :format_array]

    def initialize(missing_fields)
      @missing_fields = missing_fields
      check_for_missing_defaults
    end

    def message
      [
        missing_fields_message,
        *missing_defaults_messages
      ].join "\n\n"
    end

    private
    attr_accessor :missing_fields

    def missing_fields_message
      @missing_fields_message ||= "Missing required fields: #{missing_fields}"
    end

    def check_for_missing_defaults
      missing_fields.each do |field|
        next unless DEFAULTS.include?(field)
        missing_defaults_messages << missing_default_error_message(field)
      end
    end

    def missing_defaults_messages
      @missing_defaults_messages ||= []
    end

    def missing_default_error_message(field)
      missing_field      = "You are missing the #{field} field"
      check_for_override = "Please make sure you are not setting #{field} to nil anywhere in your configuration."
      report_issue       = "If you have not set #{field} anywhere please raise an issue on github: https://github.com/finn-francis/get_address/issues"
      [missing_field, check_for_override, report_issue].join "\n"
    end
  end
end
