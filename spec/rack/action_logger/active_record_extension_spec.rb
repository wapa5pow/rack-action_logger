require "spec_helper"

RSpec.describe Rack::ActionLogger::ActiveRecordExtension do
  let(:target_class) { Struct.new(:action_record_extension) { include described_class } }
  let(:target) { target_class.new }
  let(:column_names) { %w(password key article_id) }

  before {
    described_class.instance_variable_set(:@compiled_filters, nil)  # clear filter
    Rack::ActionLogger.configure { |c| c.filters = ['password'] }

    Rack::ActionLogger::Container.clear
    @active_record_mock = double('Active Record')
    allow(@active_record_mock.class).to receive(:after_create)
    allow(@active_record_mock.class).to receive(:after_update)
    allow(@active_record_mock.class).to receive(:after_destroy)
    allow(@active_record_mock.class).to receive(:column_names).and_return(column_names)
    allow(@active_record_mock.class).to receive(:table_name).and_return('table_name')
    allow(@active_record_mock).to receive(:password).and_return('password')
    allow(@active_record_mock).to receive(:saved_change_to_password?).and_return(true)
    allow(@active_record_mock).to receive(:password_before_last_save).and_return('old_password')
    allow(@active_record_mock).to receive(:key).and_return('key')
    allow(@active_record_mock).to receive(:saved_change_to_key?).and_return(false)
    allow(@active_record_mock).to receive(:article_id).and_return(1234)
    allow(@active_record_mock).to receive(:saved_change_to_article_id?).and_return(false)
  }

  describe 'capture_action_log_create' do
    it do
      expected = [{
          _method: 'create',
          '_password' => Rack::ActionLogger::ParameterFiltering::FILTERED,
          '_key' => 'key',
          '_article_id' => 1234,
          tag: 'model_table_name'
      }]
      @active_record_mock.class.send(:include, described_class)
      @active_record_mock.capture_action_log_create
      expect(Rack::ActionLogger::Container.append_logs).to eq expected
    end
  end

  describe 'capture_action_log_update' do
    it do
      expected = [{
          _method: 'update',
          '_after:password' => Rack::ActionLogger::ParameterFiltering::FILTERED,
          '_before:password' => Rack::ActionLogger::ParameterFiltering::FILTERED,
          '_article_id' => 1234,
          tag: 'model_table_name'
      }]
      @active_record_mock.class.send(:include, described_class)
      @active_record_mock.capture_action_log_update
      expect(Rack::ActionLogger::Container.append_logs).to eq expected
    end
  end

  describe 'capture_action_log_destroy' do
    it do
      expected = [{
          _method: 'delete',
          '_article_id' => 1234,
          tag: 'model_table_name'
      }]
      @active_record_mock.class.send(:include, described_class)
      @active_record_mock.capture_action_log_destroy
      expect(Rack::ActionLogger::Container.append_logs).to eq expected
    end
  end
end
