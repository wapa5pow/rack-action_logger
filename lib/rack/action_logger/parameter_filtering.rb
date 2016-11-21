module Rack::ActionLogger
  module ParameterFiltering
    FILTERED = '[FILTERED]'.freeze # :nodoc:

    class << self

      def apply_filter(original_params, compiled_filters)
        filtered_params = {}

        original_params.each do |key, value|
          if compiled_filters.any? { |r| key =~ r }
            value = FILTERED
          elsif value.is_a?(Hash)
            value = apply_filter(value, compiled_filters)
          elsif value.is_a?(Array)
            value = value.map { |v| v.is_a?(Hash) ? apply_filter(v, compiled_filters) : v }
          end

          filtered_params[key] = value
        end

        filtered_params
      end

      def compile(filters)
        filter_strings = filters.map(&:to_s)
        filter_strings.map { |item| Regexp.compile(Regexp.escape(item)) }
      end
    end
  end
end
