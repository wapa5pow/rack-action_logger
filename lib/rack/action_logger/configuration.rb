require 'rack/action_logger/emit_adapter/logger_adapter'
require 'rack/action_logger/emit_adapter/fluent_adapter'
require 'rack/action_logger/emit_adapter/null_adapter'
require 'logger'

module Rack::ActionLogger
  class Configuration
    attr_accessor :emit_adapter
    attr_accessor :wrap_key
    attr_accessor :default_tag
    attr_accessor :tag_prefix
    attr_accessor :logger

    def initialize
      @emit_adapter = EmitAdapter::LoggerAdapter
      @tag_prefix = 'action'
      @logger = Logger.new(STDOUT)
      @logger.progname = 'rack_action_logger'
    end

    def default_tag
      "#{@tag_prefix}.log"
    end
  end
end
