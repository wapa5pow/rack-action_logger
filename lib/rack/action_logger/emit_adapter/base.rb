require 'rack/action_logger'

module Rack::ActionLogger::EmitAdapter
  class Base
    def self.emit(hash); end

    def self.wrap(hash)
      result = {}
      wrap_key = Rack::ActionLogger.configuration.wrap_key
      if wrap_key
        result[wrap_key] = hash
      else
        result = hash
      end
      result
    end
  end
end
