module Rack::ActionLogger
  module ControllerConcerns
    extend ActiveSupport::Autoload

    autoload :RequestLog
  end
end

