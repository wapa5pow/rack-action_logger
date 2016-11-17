Rack::ActionLogger.configure do |config|
  # config.emit_adapter = Rack::ActionLogger::EmitAdapter::FluentAdapter
  config.emit_adapter = Rack::ActionLogger::EmitAdapter::LoggerAdapter
  config.wrap_key = :message
  config.logger = Rails.logger
  config.filters = Rails.application.config.filter_parameters
  config.rack_request_blacklist = []
end
