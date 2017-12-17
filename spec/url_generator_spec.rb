require 'spec_helper'

class Test
  include GetAddress::UrlGenerator
  attr_accessor :postcode, :house
end

RSpec.describe GetAddress::UrlGenerator do
  let(:generator) { Test.new }
  let(:generate_url) { generator.generate_url }

  describe '#generate_url' do
    before do
      generator.instance_variable_set '@postcode', 'POSTCODE'
    end

    context 'with postcode and house' do
      before do
        generator.instance_variable_set '@house', 'HOUSE'
      end

      it 'should return a url with a postcode and house' do
        expect(generate_url).to eq GetAddress::BASE_URL + 'POSTCODE/HOUSE'
      end
    end

    context 'with just a postcode' do
      it 'should return a url with just the postcode' do
        expect(generator.generate_url).to eq GetAddress::BASE_URL + 'POSTCODE'
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
