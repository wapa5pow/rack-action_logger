require 'rack/action_logger/emit_adapter/base'

module Rack::ActionLogger::EmitAdapter
  class FluentAdapter < Base
    def self.emit(hash)
      tag = hash[:tag] ? hash[:tag] : Rack::ActionLogger.configuration.default_tag
      hash = wrap(hash)
      Fluent::Logger.post(tag, hash)
    end
  end
end
