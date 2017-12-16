module GetAddress
  class Configuration
    attr_accessor :api_key, :format_array, :sort

    def initialize
      @format_array = false
      @sort         = true
    end

    def settings
      {
        api_key:      api_key,
        format_array: format_array,
        sort:         sort
      }
    end
  end
end
