module GetAddress
  module RequestValidator
    def valid?
      self.errors = {}
      add_to_errors(:missing_fields).nil?
    end

    def errors
      @errors ||= {}
    end

    def missing_fields
      Request::REQUIRED_FIELDS.select { |field| send(field).nil? }
    end

    private

    attr_writer :errors

    def add_to_errors(method, *args)
      result = send(method, *args)
      errors[method] = result unless result.nil? || result.empty?
    end
  end
end
