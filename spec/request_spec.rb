require "spec_helper"

RSpec.describe GetAddress::Request do
  extend SetupConfiguration

  let(:request) { GetAddress::Request.new(options) }
  let(:options) { {} }
  before { configure }

  describe "#config" do
    it "should return the GetAddress config" do
      expect(request.send(:config)).to eq config
    end
  end

  describe "#config_settings" do
    it "should return the config settings" do
      expect(request.send(:config_settings)).to eq config.settings
    end
  end

  describe "#set_options" do
    let(:options) do
      {
        postcode: "FOO",
        house:    "BAR",
        api_key:  "OVERRIDDEN_API_KEY"
      }
    end
    let(:set_options) { request.send(:set_options, options) }

    it "should set the passed_in instance variables along with the defaults from the config settings" do
      expect(set_options[:postcode]).to     eq "FOO"
      expect(set_options[:house]).to        eq "BAR"
      expect(set_options[:api_key]).to      eq "OVERRIDDEN_API_KEY"
      expect(set_options[:sort]).to         eq false
      expect(set_options[:format_array]).to eq true
    end
  end
end
