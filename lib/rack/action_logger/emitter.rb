module Rack::ActionLogger
  class Emitter

    def initialize
      @can_emit = !Container.is_emit_started
      unless @can_emit
        Rack::ActionLogger.logger.error("#{self.class} is already defined.")
        Rack::ActionLogger.logger.error("#{Thread.current.backtrace.join("\n")}")
      end
      @emit_adapter = Rack::ActionLogger.configuration.emit_adapter
      @container = Container
    end

    def emit(context=nil)
      @container.is_emit_started = true
      @container.import(context) if context
      result = yield
      emit_all_logs  # emit log unless exception raised
      result
    ensure
      @container.clear if @can_emit
    end

    private

    def emit_all_logs
      return unless @can_emit
      emit_request_log
      emit_append_logs
    end

    def emit_request_log
      return unless (@container.request_log.is_a?(Hash) && @container.request_log != {})
      hash = @container.request_log.merge @container.attributes
      hash = format_tag(hash)
      @emit_adapter.emit(hash)
    end

    def emit_append_logs
      @container.append_logs.each do |hash|
        hash = format_tag(hash)
        @emit_adapter.emit(@container.attributes.merge(hash))
      end
    end

    def format_tag(hash)
      if hash[:tag]
        hash[:tag] = [Rack::ActionLogger.configuration.tag_prefix, hash[:tag]].join('.')
      else
        hash[:tag] = Rack::ActionLogger.configuration.default_tag
      end
      hash
    end
  end
end
