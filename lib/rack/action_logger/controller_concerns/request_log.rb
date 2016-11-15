require 'rack/action_logger/container'

module Rack::ActionLogger::ControllerConcerns
  module RequestLog
    extend ActiveSupport::Concern

    included do
      before_action :set_request_log
    end

    def set_request_log
      Rack::ActionLogger::Container.set_request_log({ path_info: request.path_info, request_method: request.request_method }, 'action.request')

      request_id = Rails::VERSION::MAJOR >= 5 ? request.request_id : request.uuid
      Rack::ActionLogger::Container.merge_attributes({ request_id: request_id })
    end
  end
end
