require "spec_helper"

RSpec.describe Rack::ActionLogger::Container do
  let(:hash) { { key: 'value' } }
  let(:tag) { 'tag' }
  before { described_class.clear }

  describe 'store' do
    it 'should return empty hash as default' do
      expect(described_class.store).to be {}
    end
  end

  describe 'is_emit_started' do
    it 'should return false as default' do
      expect(described_class.get_is_emit_started).to be_falsy
    end

    it 'should return true after set' do
      expect(described_class.set_is_emit_started).to be_truthy
    end
  end

  describe 'append_log' do
    it 'should return empty hash as default' do
      expect(described_class.get_append_logs).to eq []
    end

    it 'can append log' do
      described_class.set_append_log(hash, tag)
      expected = [hash.merge({ tag: tag })]
      expect(described_class.get_append_logs).to eq expected
    end

    it 'can be the same object after changed' do
      append_log = described_class.get_append_logs
      described_class.set_append_log(hash, tag)
      expect(described_class.get_append_logs).to be append_log
    end

    it 'should log with nil tag' do
      expected = [hash.merge({ tag: nil })]
      described_class.set_append_log(hash)
      expect(described_class.get_append_logs).to eq expected
    end

    it 'should not log without invalid tag' do
      described_class.set_append_log(hash, ['test'])
      expect(described_class.get_append_logs).to eq []
    end

    it 'should not log without invalid hash' do
      described_class.set_append_log(nil, tag)
      expect(described_class.get_append_logs).to eq []
    end
  end

  describe 'attributes' do
    it 'should return empty hash as default' do
      expect(described_class.get_attributes).to be {}
    end

    it 'can merge attributes' do
      described_class.merge_attributes(hash)
      expect(described_class.get_attributes).to eq hash
    end

    it 'can be the same object after changed' do
      attributes = described_class.get_attributes
      described_class.merge_attributes(hash)
      expect(described_class.get_attributes).to be attributes
    end

    it 'should not log without invalid hash' do
      described_class.merge_attributes(nil)
      expect(described_class.get_attributes).to be {}
    end
  end

  describe 'request_log' do
    it 'should return empty hash as default' do
      expect(described_class.get_request_log).to be {}
    end

    it 'can get request log' do
      described_class.set_request_log(hash, tag)
      expected = hash.merge({ tag: tag })
      expect(described_class.get_request_log).to eq expected
    end

    it 'can be the same object after changed' do
      request_log = described_class.get_request_log
      described_class.set_request_log(hash, tag)
      expect(described_class.get_request_log).to be request_log
    end

    it 'should not log without invalid hash' do
      described_class.set_request_log(hash, ['test'])
      expect(described_class.get_request_log).to be {}
    end

    it 'should log with nil tag' do
      expected = hash.merge({ tag: nil })
      described_class.set_request_log(hash)
      expect(described_class.get_request_log).to eq expected
    end

    it 'should not log without invalid tag' do
      described_class.set_request_log(nil, tag)
      expect(described_class.get_request_log).to be {}
    end
  end

  describe 'import/export' do
    it 'can export with no attribute' do
      expect(described_class.export).to be {}
    end

    it 'can export with attributes' do
      expected_hash = { rack_action_logger_attributes: hash }
      described_class.merge_attributes(hash)
      expect(described_class.export).to eq expected_hash
    end

    it 'can import' do
      expected_hash = { rack_action_logger_attributes: hash }
      described_class.import(expected_hash)
      expect(described_class.export).to eq expected_hash
    end

    it 'can import non symbol key hash' do
      expected_hash = { 'rack_action_logger_attributes': hash }
      described_class.import(expected_hash)
      expect(described_class.export).to eq expected_hash
    end
  end
end
