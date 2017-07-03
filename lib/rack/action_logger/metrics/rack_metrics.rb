require 'rack/action_logger'
require 'rack/mock'
require 'woothee'

module Rack::ActionLogger::Metrics
  class RackMetrics
    METRICS = [
      :path, :method, :params, :request_headers, :status_code, :ip, :remote_ip, :user_agent, :device, :os, :browser,
      :browser_version, :request_id, :response_headers, :response_json_body,
    ]
    RACK_TAG_PREFIX = 'rack'
    EXCLUDE_PATH_PREFIX = '/asset'

    attr_reader :status_code

    def initialize(env, status_code, headers, body)
      @env = env
      @status_code = status_code
      @headers = headers
      @body = body
      @request = Rack::Request.new(env)
      @response = Rack::Response.new(body, status_code, headers)
      @ua = Woothee.parse(@request.user_agent)
    end

    def tag_suffix
      return RACK_TAG_PREFIX if Rack::ActionLogger.configuration.rack_unified_tag
      if @status_code == 404
        tags = ['not_found']
      else
        tags = URI(path).path.split('/').reject { |c| c.empty? }
      end
      (Array(RACK_TAG_PREFIX) + tags).join('.')
    end

    def metrics
      return unless enable_metrics
      METRICS.inject({}) do |result, metric|
        result[metric] = self.send(metric) unless
            Rack::ActionLogger.configuration.rack_request_blacklist.include? metric
        result
      end
    end

    def path
      @request.path
    end

    def method
      @request.request_method
    end

    def params
      Rack::ActionLogger::ParameterFiltering.apply_filter(@request.params)
    end

    def request_headers
      @env.select { |v| v.start_with? 'HTTP_' }
    end

    def enable_metrics
      Rack::ActionLogger.configuration.rack_content_types.any? { |c| content_type.to_s.include?(c) } || action_controller
    end

    def action_controller
      @env['action_controller.instance']
    end

    def content_type
      @response.content_type
    end

    def remote_ip
      @env['action_dispatch.remote_ip']
    end

    def ip
      @request.ip
    end

    def user_agent
      @request.user_agent
    end

    def device
      @ua[:category]
    end

    def os
      @ua[:os]
    end

    def browser
      @ua[:name]
    end

    def browser_version
      @ua[:version]
    end

    def request_id
      @env['action_dispatch.request_id']
    end

    def response_headers
      @headers
    end

    def response_json_body
      response_bodies = []
      @body.each { |part| response_bodies << part } if @body
      result = JSON.parse(response_bodies.join('')) rescue {}
      Rack::ActionLogger::ParameterFiltering.apply_filter(result)
    end
  end
end
