require "spec_helper"

RSpec.describe Rack::ActionLogger::ParameterFiltering do
  let(:hash) { { key: 'value' } }
  let(:filters) { %w(password secret) }

  describe 'compile' do
    it 'should be success' do
      expect(described_class.compile(filters)).not_to be_nil
    end
  end

  describe 'apply_filter' do
    it 'should not filter with un-filter key' do
      compiled_filter = described_class.compile(filters)
      expect(described_class.apply_filter(hash, compiled_filter)).to eq hash
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
      compiled_filter = described_class.compile(filters)
      expect(described_class.apply_filter(filtered_hash, compiled_filter)).to eq expected_filtered_hash
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
      compiled_filter = described_class.compile(filters)
      expect(described_class.apply_filter(filtered_hash, compiled_filter)).to eq expected_filtered_hash
    end
  end
end
