require 'spec_helper'

RSpec.describe GetAddress::Configuration do
  extend SetupConfiguration

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
      let(:expected_mappings) do
        {
          line_1:    0,
          line_2:    1,
          line_3:    2,
          line_4:    3,
          locality:  4,
          town:      5,
          country:   6
        }
      end
      it 'should return the key mappings' do
        expect(config.keymap).to eq expected_mappings
      end
    end

    describe '#keymap=' do
      let(:keymap) { { locality: :county } }
      before { config.keymap = keymap }

      it 'should set the keymap and keymap' do
        expect(config.keymap).to eq expected_keymappings
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
end
