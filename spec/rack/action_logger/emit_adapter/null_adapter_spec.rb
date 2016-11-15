require 'spec_helper'
require 'rack/action_logger/emit_adapter/null_adapter'

RSpec.describe Rack::ActionLogger::EmitAdapter::NullAdapter do
  let(:hash) { { key: 'value' } }

  describe 'emit' do
    it 'should emit nothing' do
      expect(described_class.emit(hash)).not_to eq raise_error
    end

  end
end
