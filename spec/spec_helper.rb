require 'rspec'
require 'simplecov'
require 'rack/action_logger'
require 'rack/action_logger/emit_adapter/null_adapter'
require 'helper/test_application_helper'

Rack::ActionLogger.configure do |config|
  config.emit_adapter = Rack::ActionLogger::EmitAdapter::NullAdapter
  config.wrap_key = nil
  config.logger = Logger.new(nil)
end
