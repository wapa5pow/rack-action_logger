module Rack::ActionLogger
  module EmitAdapter
    extend ActiveSupport::Autoload

    autoload :FluentAdapter
    autoload :LoggerAdapter
    autoload :NullAdapter
  end
end
