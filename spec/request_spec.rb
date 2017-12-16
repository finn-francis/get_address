require "spec_helper"

RSpec.describe GetAddress::Request do
  extend SetupConfiguration

  let(:request) { GetAddress::Request.new(options) }
  let(:options) { { postcode: "FOO" } }
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
  it "should require a postcode" do
    expect { GetAddress::Request.new({}) }.to raise_error(ArgumentError).with_message("Missing keyword argument: :postcode")
  end

  describe "#set_options" do
    let(:options) do
      {
        postcode: "FOO",
        house:    "BAR",
        api_key:  "OVERRIDDEN_API_KEY"
      }
    end
    let(:set_options) { request.send(:set_options) }

    before { request.instance_variable_set("@options", options) }

    it "should set the passed_in instance variables along with the defaults from the config settings" do
      expect(set_options[:postcode]).to     eq "FOO"
      expect(set_options[:house]).to        eq "BAR"
      expect(set_options[:api_key]).to      eq "OVERRIDDEN_API_KEY"
      expect(set_options[:sort]).to         eq false
      expect(set_options[:format_array]).to eq true
    end

    context "unpermitted options are sent through" do
      let(:options) { { unnallowed_option: false, postcode: "postcode" } }

      it "should not set the @unallowed_option variable" do
        set_options
        expect(request.instance_variable_get('@unnallowed_option')).to be nil
      end
    end
  end

  describe "PERMITTED_VALUES" do
    let(:permitted_values) do
      [:api_key, :format_array, :sort, :postcode, :house]
    end
    it "should contain all the values that are allowed to be passed in to the initializer" do
       expect(GetAddress::Request::PERMITTED_VALUES).to eq permitted_values
    end
  end
end
