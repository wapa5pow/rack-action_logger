require 'rack/action_logger/emit_adapter/base'

module Rack::ActionLogger::EmitAdapter
  class NullAdapter < Base
    # Emit nothing
  end
end
