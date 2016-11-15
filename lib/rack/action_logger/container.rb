require 'active_support'
require 'active_support/core_ext'

module Rack::ActionLogger
  module Container
    THREAD_KEY = :rack_action_logger
    EXPORT_KEYS = [:rack_action_logger_attributes]

    class << self
      def store
        Thread.current[THREAD_KEY] ||= {}
      end

      def clear
        Thread.current[THREAD_KEY] = nil
      end

      def set_is_emit_started
        store[:rack_action_logger_emit_started] = true
      end

      def get_is_emit_started
        store[:rack_action_logger_emit_started] ||= false
      end

      def set_append_log(hash, tag)
        return unless is_valid_hash hash
        return unless is_valid_tag tag
        hash[:tag] = tag
        get_append_logs.push(hash)
      end

      def get_append_logs
        store[:rack_action_logger_append_logs] ||= []
      end

      def merge_attributes(attributes)
        return unless is_valid_hash attributes
        get_attributes.merge! attributes
      end

      def get_attributes
        store[:rack_action_logger_attributes] ||= {}
      end

      def set_request_log(hash, tag)
        return unless is_valid_hash hash
        return unless is_valid_tag tag
        hash[:tag] = tag
        get_request_log.merge! hash
      end

      def get_request_log
        store[:rack_action_logger_request_log] ||= {}
      end

      def export
        # ここenumerableで置き換える
        hash = {}
        EXPORT_KEYS.each do |key|
          hash[key] = store[key] if store[key]
        end
        hash
      end

      def import(hash)
        hash.symbolize_keys.each do |key, value|
          next unless EXPORT_KEYS.include? key
          store[key] = value
        end
      end

      private

      def is_valid_hash(hash)
        if hash.is_a? Hash
          true
        else
          Rack::ActionLogger.logger.error("invalid hash: #{hash}")
          false
        end
      end

      def is_valid_tag(tag)
        if tag.is_a? String
          true
        else
          Rack::ActionLogger.logger.error("invalid tag: #{tag}")
          false
        end
      end
    end

  end
end
