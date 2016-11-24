require "spec_helper"

RSpec.describe Rack::ActionLogger::ParameterFiltering do
  let(:hash) { { key: 'value' } }
  let(:filters) { %w(password secret) }

  before {
    described_class.instance_variable_set(:@compiled_filters, nil)  # clear filter
    Rack::ActionLogger.configure { |c| c.filters = filters }
  }

  describe 'compile' do
    it 'should be success' do
      expect(described_class.send(:compile, filters)).not_to be_nil
    end
  end

  describe 'apply_filter' do
    it 'should not filter with un-filter key' do
      expect(described_class.apply_filter(hash)).to eq hash
    end

    it 'should filter hash with filter keys' do
      filtered_hash = {
        password: 'password',
        secret: 'secret',
        un_filter: 'value'
      }
      expected_filtered_hash = {
        password: "#{described_class::FILTERED}",
        secret: "#{described_class::FILTERED}",
        un_filter: 'value'
      }
      expect(described_class.apply_filter(filtered_hash)).to eq expected_filtered_hash
    end

    it 'should filter hash array with filter keys' do
      filtered_hash = {
        values: [
          password: 'password',
          secret: 'secret',
          un_filter: 'value'
        ]
      }
      expected_filtered_hash = {
        values: [
          password: "#{described_class::FILTERED}",
          secret: "#{described_class::FILTERED}",
          un_filter: 'value'
        ]
      }
      expect(described_class.apply_filter(filtered_hash)).to eq expected_filtered_hash
    end

    it 'should filter hash array with filter keys containing underscore' do
      filtered_hash = {
        values: [
          _password: 'password',
          secret: 'secret',
          un_filter: 'value'
        ]
      }
      expected_filtered_hash = {
        values: [
          _password: "#{described_class::FILTERED}",
          secret: "#{described_class::FILTERED}",
          un_filter: 'value'
        ]
      }
      expect(described_class.apply_filter(filtered_hash)).to eq expected_filtered_hash
    end

  end
end
