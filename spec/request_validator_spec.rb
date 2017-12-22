require 'spec_helper'

class RequestValidatorTest
  include GetAddress::RequestValidator
  attr_reader :api_key, :format_array, :sort, :postcode

  def test_error(message)
    message
  end
end

RSpec.describe GetAddress::RequestValidator do
  let(:instance) { RequestValidatorTest.new }

  shared_context 'there are no missing fields' do
    before { allow_any_instance_of(RequestValidatorTest).to receive(:missing_fields).and_return([])}
  end

  describe '#valid?' do
    context 'there are no errors' do
      include_context 'there are no missing fields'
      it 'should return true' do
        expect(instance.valid?).to eq true
      end
    end

    context 'there are errors' do
      it 'should return false' do
        expect(instance.valid?).to eq false
      end
    end
  end

  describe '#errors' do
    context 'there are no errors' do
      include_context 'there are no missing fields'
      it 'should return an empty hash' do
        expect(instance.errors).to eq({})
      end
    end

    context 'there are errors' do
      before { instance.valid? }
      it 'should return a hash with errors' do
        expect(instance.errors).to eq({ missing_fields:[:api_key, :format_array, :sort, :postcode] })
      end
    end
  end

  describe '#missing_fields' do
    context 'there are no missing fields' do
      include_context 'there are no missing fields'
      it 'should return an empty array' do
        expect(instance.send(:missing_fields)).to eq []
      end
    end

    context 'there are missing fields' do
      it 'should return an array of the missing fields' do
        expect(instance.send(:missing_fields)).to eq [:api_key, :format_array, :sort, :postcode]
      end
    end
  end

  describe '#add_to_errors' do
    let!(:method) { instance.send(:add_to_errors, :test_error, 'my test message') }
    it 'should add a key to the error hash' do
      expect(instance.errors[:test_error]).to eq 'my test message'
    end
  end
end
