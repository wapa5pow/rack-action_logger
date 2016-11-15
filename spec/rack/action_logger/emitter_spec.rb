require "spec_helper"

RSpec.describe Rack::ActionLogger::Emitter do
  let(:hash) { { key: 'value' } }
  let(:tag) { 'tag' }
  before { Rack::ActionLogger::Container.clear }

  describe 'emit' do
    it 'can be initialize' do
      expect(described_class.new).to be_an_instance_of(described_class)
    end

    it 'can emit without log' do
      expect { described_class.new.emit {} }.not_to raise_error
    end

    it 'can emit with log' do
      Rack::ActionLogger::Container.set_request_log(hash, tag)
      expect{ described_class.new.emit {} }.not_to raise_error
    end

    it 'can be nested but logged error' do
      adapter_mock = double('Emit Adapter')
      expected = hash.merge({ tag: tag })
      expect(adapter_mock).to receive(:emit).with(expected)
      Rack::ActionLogger::Container.set_request_log(hash, tag)
      emitter = described_class.new
      emitter.instance_variable_set(:@emit_adapter, adapter_mock)
      emitter.emit {}
    end

    it 'should clear container after emit' do
      Rack::ActionLogger::Container.set_request_log(hash, tag)
      expect(Rack::ActionLogger::Container.store).not_to be_empty
      described_class.new.emit {}
      expect(Rack::ActionLogger::Container.store).to be_empty
    end

    it 'should clear container after emit with exception' do
      Rack::ActionLogger::Container.set_request_log(hash, tag)
      expect(Rack::ActionLogger::Container.store).not_to be_empty
      expect{ described_class.new.emit { raise StandardError } }.to raise_error(StandardError)
      expect(Rack::ActionLogger::Container.store).to be_empty
    end

  end
end
