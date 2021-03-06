module GetAddress
  class Configuration
    attr_accessor :api_key, :format_array, :sort

    def initialize
      @format_array = false
      @sort         = true
    end

    def keymap=(mappings)
      mappings.each do |old_mapping, new_mapping|
        keymap[new_mapping] = keymap.delete(old_mapping)
      end
    end

    def settings
      {
        api_key:      api_key,
        format_array: format_array,
        sort:         sort
      }
    end

    def keymap
      @keymap ||= {
        line_1:   0,
        line_2:   1,
        line_3:   2,
        line_4:   3,
        locality: 4,
        town:     5,
        country:  6
      }
    end
  end
end
