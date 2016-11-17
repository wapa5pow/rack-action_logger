require 'active_support'

module Rack::ActionLogger
  module Metrics
    extend ActiveSupport::Autoload

    autoload :RackMetrics
  end
end

