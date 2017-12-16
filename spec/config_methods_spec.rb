require "spec_helper"

class Test
  include GetAddress::ConfigMethods
end

RSpec.describe GetAddress::ConfigMethods do
  extend SetupConfiguration

  let(:test) { Test.new }

  before { configure }

  describe "#config" do
    it "should return the GetAddress config" do
      expect(test.send(:config)).to eq config
    end
  end

  describe "#config_settings" do
    it "should return the config settings" do
      expect(test.send(:config_settings)).to eq config.settings
    end
  end
end
