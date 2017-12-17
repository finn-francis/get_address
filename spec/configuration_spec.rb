require 'spec_helper'
require 'get_address/configuration'

RSpec.describe GetAddress::Configuration do
  extend SetupConfiguration

  describe 'attributes' do
    let(:config)     { GetAddress::Configuration.new }
    let(:attributes) { [:api_key, :format_array, :sort] }

    it 'should have getters and setters for api_key, format_array and sort' do
      attributes.each do |attribute|
        expect(config).to respond_to(attribute)
        expect(config).to respond_to("#{attribute}=".to_sym)
      end
    end

    describe '#keymap' do
      it 'should return the key mappings' do
        expect(config.keymap).to eq [:line_1, :line_2, :line_3, :line_4, :locality, :town, :country]
      end
    end

    describe '#keymap=' do
      let(:keymap) { { locality: :county } }
      let(:expected_keymappings) do
        {
          line_1:  0,
          line_2:  1,
          line_3:  2,
          line_4:  3,
          county:  4,
          town:    5,
          country: 6
        }
      end
      before { config.keymap = keymap }

      it 'should set the keymap and keymappings' do
        expect(config.keymap).to eq [:line_1, :line_2, :line_3, :line_4, :county, :town, :country]
        expect(config.send(:keymappings)).to eq expected_keymappings
      end
    end
  end

  describe '#settings' do
    let(:expected_settings) do
      {
        api_key:      'MY_API_KEY',
        format_array: true,
        sort:         false
      }
    end
    before { configure }

    it 'should return a hash of the configuration settings' do
      expect(config.settings).to eq(expected_settings)
    end
  end

  describe '#keymappings' do
    let(:keymappings) do
      {
        line_1:   0,
        line_2:   1,
        line_3:   2,
        line_4:   3,
        locality: 4,
        town:     5,
        country:  6
      }
    end
    it 'should return the keymappings' do
      expect(config.send(:keymappings)).to eq keymappings
    end
  end
end
