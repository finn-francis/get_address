require 'spec_helper'

class Test
  include GetAddress::UrlGenerator
  attr_accessor :postcode, :house, :api_key, :format_array, :sort

  def initialize
    @postcode     = 'POSTCODE'
    @api_key      = 'MY_API_KEY'
    @format_array = false
    @sort         = true
  end
end

RSpec.describe GetAddress::UrlGenerator do
  let(:generator)    { Test.new }
  let(:generate_url) { generator.generate_url }
  let(:query_string) { '?api-key=MY_API_KEY&format=false&sort=true' }

  describe '#generate_url' do
    context 'with postcode and house' do
      before { generator.instance_variable_set '@house', 'HOUSE' }

      it 'should return a url with a postcode and house' do
        expect(generate_url).to eq GetAddress::BASE_URL + 'POSTCODE/HOUSE' + query_string
      end
    end

    context 'with just a postcode' do
      it 'should return a url with just the postcode' do
        expect(generator.generate_url).to eq GetAddress::BASE_URL + 'POSTCODE' + query_string
      end
    end
  end

  describe '#url' do
    before { generate_url }

    it 'should return the full url' do
      expect(generator.url).to eq generate_url
    end
  end

  describe '#append_query' do
    it 'should append the query to the end of the string passed in' do
      expect(generator.send(:append_query, 'my_url')).to eq 'my_url' + query_string
    end
  end
end
