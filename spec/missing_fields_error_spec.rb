require 'spec_helper'

RSpec.describe do
  let(:missing_fields)   { [:api_key, :sort, :format_array] }
  let(:missing_defaults) { [:sort, :format_array ] }
  let(:expected_message) { "Missing required fields: #{missing_fields}" }
  let!(:instance)        { GetAddress::MissingFieldsError.new(missing_fields) }

  def missing_field_message(missing_field)
    "You are missing the #{missing_field} field\nPlease make sure you are not setting #{missing_field} to nil anywhere in your configuration.\nIf you have not set #{missing_field} anywhere please raise an issue on github: https://github.com/finn-francis/get_address/issues"
  end

  describe '#initialize' do
    it 'should set the missing_defaults, missing_defaults_messages, and missing_fields instance variables' do
      expect(instance.send(:missing_defaults_messages).length).to eq 2
      expect(instance.send(:missing_fields)).to eq missing_fields
    end
  end

  describe '#message' do
    let(:message) { instance.send(:message) }
    
    it 'should render a message' do
      expect(message).to include expected_message
      expect(message).to include missing_field_message('sort')
      expect(message).to include missing_field_message('format_array')
    end
  end

  describe '#missing_fields_message' do
    it 'should display the missing fields messgae' do
      expect(instance.send(:missing_fields_message)).to eq expected_message
    end
  end

  describe '#check_for_missing_defaults' do
    let(:method)           { instance.send(:check_for_missing_defaults) }
    let(:missing_defaults) { instance.send(:missing_defaults_messages) }

    it 'should populate the missing defaults messages variable' do
      expect { method }.to change {  missing_defaults.length }.by 2
    end
  end

  describe '#missing_defaults_messages' do
    context 'there are missing defaults' do
      let(:missing_defaults) { instance.send(:missing_defaults_messages) }

      it 'should return an array of error messages for the missing defaults' do
        expect(missing_defaults.length).to eq 2
        expect(missing_defaults.first).to eq missing_field_message('sort')
        expect(missing_defaults.last).to eq missing_field_message('format_array')
      end
    end

    context 'there are no missing defaults' do
      let(:missing_fields) { [] }
      it 'should return an empty array' do
        expect(instance.send(:missing_defaults_messages)).to eq []
      end
    end
  end

  describe '#missing_default_error_message' do
    it 'should return a string with details on how to debug the missing default' do
      expect(instance.send(:missing_default_error_message, 'TEST')).to eq missing_field_message('TEST')
    end
  end
end
