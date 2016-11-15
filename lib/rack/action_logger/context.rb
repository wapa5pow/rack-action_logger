module Rack::ActionLogger
  class Context

    def initialize(app)
      @app = app
    end

    def call(env)
      Emitter.new.emit do
        @app.call(env)
      end
    end

  end
end
