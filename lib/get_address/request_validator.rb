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
      # TODO Add a message if sort or format_array is missing
      # first tell them to check that they didn't set either of them to nil
      # if the didn't tell them to submit an issue on github
      Request::REQUIRED_FIELDS.select { |field| send(field).nil? }
    end

    private

    attr_writer :errors
  end
end
