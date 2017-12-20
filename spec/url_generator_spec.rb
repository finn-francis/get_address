require 'spec_helper'

class Test
  include GetAddress::UrlGenerator
  attr_accessor :postcode, :house, :api_key

  def initialize
    @postcode = 'POSTCODE'
    @api_key  = 'MY_API_KEY'
  end
end

RSpec.describe GetAddress::UrlGenerator do
  let(:generator) { Test.new }
  let(:generate_url) { generator.generate_url }

  describe '#generate_url' do
    context 'with postcode and house' do
      before do
        generator.instance_variable_set '@house', 'HOUSE'
      end

      it 'should return a url with a postcode and house' do
        expect(generate_url).to eq GetAddress::BASE_URL + 'POSTCODE/HOUSE' + '?api-key=MY_API_KEY'
      end
    end

    context 'with just a postcode' do
      it 'should return a url with just the postcode' do
        expect(generator.generate_url).to eq GetAddress::BASE_URL + 'POSTCODE' + '?api-key=MY_API_KEY'
      end
    end
  end

  describe '#url' do
    before { generate_url }

    it 'should return the full url' do
      expect(generator.url).to eq generate_url
    end
  end
end
