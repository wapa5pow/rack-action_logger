require 'rack/action_logger/container'

module Rack::ActionLogger::ControllerConcerns
  module RequestLog
    extend ActiveSupport::Concern

    included do
      before_action :set_request_log
    end

    def set_request_log
      Rack::ActionLogger::Container.set_request_log({ path_info: @_env['PATH_INFO'], request_method: @_env['REQUEST_METHOD'] }, 'action.request')
      Rack::ActionLogger::Container.merge_attributes({ request_id: @_env['action_dispatch.request_id'] })
    end
  end
end
