require 'active_support'
require 'active_support/core_ext'

module Rack::ActionLogger
  module Container
    THREAD_KEY = :rack_action_logger
    EXPORT_KEYS = [:rack_action_logger_attributes]

    class << self

      def clear
        Thread.current[THREAD_KEY] = nil
      end

      def is_emit_started=(value)
        store[:rack_action_logger_emit_started] = value
      end

      def is_emit_started
        store[:rack_action_logger_emit_started] ||= false
      end

      def add_append_log(hash, tag=nil)
        return unless is_valid_hash hash
        return unless is_valid_tag tag
        hash[:tag] = tag
        append_logs.push(hash)
      end

      def append_logs
        store[:rack_action_logger_append_logs] ||= []
      end

      def merge_attributes(attributes)
        return unless is_valid_hash attributes
        self.attributes = self.attributes.merge! attributes
      end

      def attributes
        store[:rack_action_logger_attributes] ||= {}
      end

      def set_request_log(hash, tag=nil)
        return unless is_valid_hash hash
        return unless is_valid_tag tag
        hash[:tag] = tag
        self.request_log = hash
      end

      def request_log
        store[:rack_action_logger_request_log] ||= {}
      end

      def export
        EXPORT_KEYS.inject({}) do |result, key|
          result[key] = store[key] if store[key]
          result
        end
      end

      def import(hash)
        hash.symbolize_keys.each do |key, value|
          next unless EXPORT_KEYS.include? key
          store[key] = value
        end
      end

      private

      def store
        Thread.current[THREAD_KEY] ||= {}
      end

      def is_valid_hash(hash)
        if hash.is_a? Hash
          true
        else
          Rack::ActionLogger.logger.error("invalid hash: #{hash}")
          false
        end
      end

      def is_valid_tag(tag)
        if tag.nil? || tag.is_a?(String)
          true
        else
          Rack::ActionLogger.logger.error("invalid tag: #{tag}")
          false
        end
      end

      def attributes=(value)
        store[:rack_action_logger_attributes] = value
      end

      def request_log=(value)
        store[:rack_action_logger_request_log] = value
      end
    end

  end
end
