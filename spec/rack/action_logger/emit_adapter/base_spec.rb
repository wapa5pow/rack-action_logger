require "spec_helper"
require 'rack/action_logger/emit_adapter/base'

RSpec.describe Rack::ActionLogger::EmitAdapter::Base do
  let(:hash) { { key: 'value' } }

  describe 'wrap' do
    it 'should work without key' do
      Rack::ActionLogger.configure do |config|
        config.wrap_key = nil
      end
      expect(described_class.wrap(hash)).to eq hash
    end

    it 'should work with key' do
      Rack::ActionLogger.configure do |config|
        config.wrap_key = :message
      end
      expected = { message: hash }
      expect(described_class.wrap(hash)).to eq expected
    end
  end
end
