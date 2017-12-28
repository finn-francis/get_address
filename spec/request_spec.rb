require 'spec_helper'

RSpec.describe GetAddress::Request do
  extend SetupConfiguration

  let(:request) { GetAddress::Request.new(options) }
  let(:options) { { postcode: 'FOO' } }
  before { configure }

  shared_context 'there are missing fields' do
    before do
      request.instance_variable_set '@api_key', nil
      request.valid?
    end

    let(:missing_api_key) { { missing_fields: [:api_key] } }
  end

  shared_examples 'it raises a missing fields error' do
    it 'should raise an error' do
      expect { request.send_request }.to raise_error(GetAddress::MissingFieldsError)
    end
  end

  it 'should require a postcode' do
    expect { GetAddress::Request.new({}) }.to raise_error(ArgumentError).with_message('Missing keyword argument: :postcode')
  end

  describe 'set_options' do
    let(:options) do
      {
        postcode: 'FOO',
        house:    'BAR',
        api_key:  'OVERRIDDEN_API_KEY'
      }
    end
    let!(:set_options) { request.send(:set_options) }

    before { request.instance_variable_set('@options', options) }

    it 'should set the passed_in instance variables along with the defaults from the config settings' do
      expect(set_options[:postcode]).to     eq 'FOO'
      expect(set_options[:house]).to        eq 'BAR'
      expect(set_options[:api_key]).to      eq 'OVERRIDDEN_API_KEY'
      expect(set_options[:sort]).to         eq false
      expect(set_options[:format_array]).to eq true
    end

    context 'unpermitted options are sent through' do
      let(:options) { { unnallowed_option: false, postcode: 'postcode' } }

      it 'should not set the @unallowed_option variable' do
        expect(request.instance_variable_get('@unnallowed_option')).to be nil
      end
    end

    context 'house is sent through as an empty string' do
      let(:options) { { postcode: 'FOO' } }

      it 'should set house to nil' do
        expect(request.house).to be_nil
      end
    end
  end

  describe '#send_request' do
    it 'should not raise an error' do
      expect(request.send_request).to be_truthy
    end

    context 'there are missing fields' do
      include_context 'there are missing fields'
      it_behaves_like 'it raises a missing fields error'

      context 'including defaults' do
        before do
          request.instance_variable_set('@sort', nil)
          request.instance_variable_set('@format_array', nil)
        end
        it_behaves_like 'it raises a missing fields error'
      end
    end
  end

  describe 'PERMITTED_VALUES' do
    let(:permitted_values) do
      [:api_key, :format_array, :sort, :postcode, :house]
    end
    it 'should contain all the values that are allowed to be passed in to the initializer' do
       expect(GetAddress::Request::PERMITTED_VALUES).to eq permitted_values
    end
  end
end
