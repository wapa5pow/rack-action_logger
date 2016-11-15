$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rack/action_logger'
require 'rack/action_logger/emit_adapter/null_adapter'

Rack::ActionLogger.configure do |config|
  config.emit_adapter = Rack::ActionLogger::EmitAdapter::NullAdapter
  config.wrap_key = nil
  config.logger = Logger.new(nil)
end
