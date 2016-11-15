require 'rack/action_logger/configuration'

module Rack::ActionLogger
  class << self
    attr_accessor :configuration
  end

  def self.new(app)
    Context.new(app)
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.logger
    configuration.logger
  end

  autoload :Configuration, 'rack/action_logger/configuration'
  autoload :Container, 'rack/action_logger/container'
  autoload :Context, 'rack/action_logger/context'
  autoload :Emitter, 'rack/action_logger/emitter'
  autoload :ControllerConcerns, 'rack/action_logger/controller_concerns'
end
