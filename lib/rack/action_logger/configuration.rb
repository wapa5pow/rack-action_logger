require 'rack/action_logger/emit_adapter/logger_adapter'
require 'rack/action_logger/emit_adapter/fluent_adapter'
require 'rack/action_logger/emit_adapter/null_adapter'
require 'logger'

module Rack::ActionLogger
  class Configuration
    DEFAULT_TAG_PREFIX = 'action'

    attr_accessor :emit_adapter
    attr_accessor :wrap_key
    attr_accessor :tag_prefix
    attr_accessor :logger
    attr_accessor :filters
    attr_accessor :rack_request_blacklist
    attr_accessor :pretty_print
    attr_accessor :rack_metrics
    attr_accessor :rack_content_types
    attr_accessor :rack_unified_tag

    def initialize
      @emit_adapter = EmitAdapter::LoggerAdapter
      @tag_prefix = DEFAULT_TAG_PREFIX
      @logger = Logger.new(STDOUT)
      @logger.progname = 'rack-action_logger'
      @filters = ['password']
      @rack_request_blacklist = [:request_headers, :response_headers, :response_json_body]
      @pretty_print = true
      @rack_metrics = Rack::ActionLogger::Metrics::RackMetrics
      @rack_content_types = %w(text/html application/json)
      @rack_unified_tag = true
    end

    def tag_prefix
      if @tag_prefix.to_s.empty?
        Rack::ActionLogger.logger.error('tag_prefix should not be empty')
        @tag_prefix = DEFAULT_TAG_PREFIX
      end
      @tag_prefix
    end

    def default_tag
      [tag_prefix, 'log'].join('.')
    end
  end
end
