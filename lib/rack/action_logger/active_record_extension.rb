require 'active_support'
require 'active_support/core_ext'

module Rack::ActionLogger
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      after_create :capture_action_log_create
      after_update :capture_action_log_update
      after_destroy :capture_action_log_destroy
    end

    def capture_action_log_create
      record = { _method: 'create' }
      self.class.column_names.each do |column_name|
        record["_#{column_name}"] = self.try(column_name)
      end
      record = Rack::ActionLogger::ParameterFiltering.apply_filter(record)
      Rack::ActionLogger::Container.set_append_log(record, "model_#{self.class.table_name}")
    end

    def capture_action_log_update
      record = { _method: 'update' }
      self.class.column_names.each do |column_name|
        if column_name.end_with?('_id')
          record["_#{column_name}"] = self.try(column_name)
        elsif self.try("#{column_name}_changed?")
          record["_after:#{column_name}"] = self.try(column_name)
          record["_before:#{column_name}"] = self.try("#{column_name}_was")
        end
      end
      record = Rack::ActionLogger::ParameterFiltering.apply_filter(record)
      Rack::ActionLogger::Container.set_append_log(record, "model_#{self.class.table_name}")
    end

    def capture_action_log_destroy
      record = { _method: 'delete' }
      self.class.column_names.each do |column_name|
        if column_name == 'id' || column_name.end_with?('_id')
          record["_#{column_name}"] = self.try(column_name)
        end
      end
      record = Rack::ActionLogger::ParameterFiltering.apply_filter(record)
      Rack::ActionLogger::Container.set_append_log(record, "model_#{self.class.table_name}")
    end
  end
end
