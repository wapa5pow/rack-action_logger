require 'rack/action_logger/emit_adapter/base'

module Rack::ActionLogger::EmitAdapter
  class LoggerAdapter < Base
    def self.emit(hash)
      hash = wrap(hash)
      Rack::ActionLogger.logger.info(hash)
    end
  end
end
