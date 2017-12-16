require "spec_helper"
require "get_address/configuration"

RSpec.describe GetAddress::Configuration do
  extend SetupConfiguration

  describe "attributes" do
    let(:config)     { GetAddress::Configuration.new }
    let(:attributes) { [:api_key, :format_array, :sort] }

    it "should have getters and setters for all attributes" do
      attributes.each do |attribute|
        expect(config).to respond_to(attribute)
        expect(config).to respond_to("#{attribute}=".to_sym)
      end
    end
  end

  describe "#settings" do
    let(:expected_settings) do
      {
        api_key:      "MY_API_KEY",
        format_array: true,
        sort:         false
      }
    end
    before { configure }

    it "should return a hash of the configuration settings" do
      expect(config.settings).to eq(expected_settings)
    end
  end
end
