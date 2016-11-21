require 'json'
require 'rack/action_logger/emit_adapter/base'

module Rack::ActionLogger::EmitAdapter
  class LoggerAdapter < Base
    def self.emit(hash)
      hash = wrap(hash)
      if Rack::ActionLogger.configuration.pretty_print
        Rack::ActionLogger.logger.info(JSON.pretty_generate(hash))
      else
        Rack::ActionLogger.logger.info(hash)
      end
    end
  end
end
