module Rack::ActionLogger
  class Context

    def initialize(app)
      @app = app
    end

    def call(env)
      Emitter.new.emit do
        status_code, headers, body = @app.call(env)
        capture_rack_log(env, status_code, headers, body)
        [status_code, headers, body]
      end
    end

    def capture_rack_log(env, status_code, headers, body)
      rack_metrics = Rack::ActionLogger.configuration.rack_metrics.new(env, status_code, headers, body)
      return if rack_metrics.metrics.nil?
      Rack::ActionLogger::Container.set_request_log(rack_metrics.metrics, rack_metrics.tag_suffix)
      Rack::ActionLogger::Container.merge_attributes({ request_id: rack_metrics.request_id })
    end

  end
end
