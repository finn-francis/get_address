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

  shared_examples 'it is valid' do
    it 'should return true' do
      expect(request.valid?).to be true
    end
  end

  shared_examples 'it is not valid' do
    it 'should return false' do
      expect(request.valid?).to be false
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
    let(:set_options) { request.send(:set_options) }

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
        set_options
        expect(request.instance_variable_get('@unnallowed_option')).to be nil
      end
    end
  end

    context 'there are missing fields' do
      include_context 'there are missing fields'
      it 'should raise an error' do
        expect { request.send_request }.to raise_error(GetAddress::MissingFieldsError).with_message('Missing required fields: [:api_key]')
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

  describe '#klass' do
    it 'should return the class' do
      expect(request.send(:klass)).to be GetAddress::Request
    end
  end

  describe '#valid?' do
    context 'it is valid' do
      it_behaves_like 'it is valid'
    end

    context 'it is not valid' do
      include_context 'there are missing fields'
      it_behaves_like 'it is not valid'

      it 'should return false' do
        expect(request.errors).to eq missing_api_key
      end
    end
  end

  describe '#errors' do
    context 'there are errors' do
      include_context 'there are missing fields'
      it_behaves_like 'it is not valid'

      it 'should return a list of all the errors' do
        expect(request.errors).to eq missing_api_key
      end
    end

    context 'there are no errors' do
      it_behaves_like 'it is valid'
      it 'should return an empty array' do
        expect(request.errors).to match_array []
      end
    end
  end

  describe '#missing_fields' do
    context 'no missing fields' do
      it 'should return an empty array' do
        expect(request.missing_fields).to eq []
      end
    end

    context 'missing fields' do
      include_context 'there are missing fields'

      it 'should return all missing fields' do
        expect(request.missing_fields).to eq [:api_key]
      end
    end
  end

  describe '#add_to_errors' do
    context 'there are errors' do
      let(:missing_api_key) { { missing_fields: [:api_key] } }
      before { request.instance_variable_set '@api_key', nil }

      it 'should add an error to the errors array' do
        expect { request.send(:add_to_errors, :missing_fields) }.to change { request.errors }.to missing_api_key
      end
    end

    context 'there are no errors' do
      it 'should add an error to the errors array' do
        expect { request.send(:add_to_errors, :missing_fields) }.to_not change { request.errors }
      end
    end
  end
end
