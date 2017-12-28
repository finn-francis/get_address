module GetAddress
  class Configuration
    attr_accessor :api_key, :format_array, :sort

    def initialize
      @format_array = false
      @sort         = true
    end

    def keymap=(mappings)
      mappings.each do |old_mapping, new_mapping|
        keymappings[new_mapping] = keymappings.delete(old_mapping)
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
      keymappings.sort_by {|k, v| v}.map(&:first)
    end

    def raw_keymap
      keymappings
    end

    private

    # TODO maybe make this public
    def keymappings
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
