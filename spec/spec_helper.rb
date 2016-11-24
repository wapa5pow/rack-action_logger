require 'rspec'
require 'simplecov'
require 'codeclimate-test-reporter'

dir = File.join('coverage')
SimpleCov.coverage_dir(dir)

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/example/'
  add_filter '/docs/'

  add_group 'lib', 'lib'
end

require 'rack/action_logger'
require 'rack/action_logger/emit_adapter/null_adapter'
require 'helper/test_application_helper'

Rack::ActionLogger.configure do |config|
  config.emit_adapter = Rack::ActionLogger::EmitAdapter::NullAdapter
  config.wrap_key = nil
  config.logger = Logger.new(nil)
end
