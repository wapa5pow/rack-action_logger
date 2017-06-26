require "spec_helper"

RSpec.describe Rack::ActionLogger::Metrics::RackMetrics do
  let(:user_agent) { 'Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10' }
  let(:env) { Rack::MockRequest.env_for('/path/to?key=value', 'HTTP_USER_AGENT' => user_agent) }
  let(:status_code) { 200 }
  let(:response_header) { { 'content-length' => 5869, 'content-type' => 'text/html' } }
  let(:response_body) { [{'key' => 'body'}.to_json.to_s] }
  let(:ip) { '127.0.0.1' }
  let(:target) {
    env['REMOTE_ADDR'] = ip
    described_class.new(env, status_code, response_header, response_body)
  }

  describe 'new' do
    it 'should initialize instance' do
      expect(described_class.new(env, status_code, response_header, response_body)).not_to be_nil
    end
  end

  describe 'tag_suffix' do
    it 'should return separate tag' do
      Rack::ActionLogger.configure { |config| config.rack_unified_tag = false }
      expect(target.tag_suffix).to eq "#{described_class::RACK_TAG_PREFIX}.path.to"
    end

    it 'should return unified tag' do
      Rack::ActionLogger.configure { |config| config.rack_unified_tag = true }
      expect(target.tag_suffix).to eq "#{described_class::RACK_TAG_PREFIX}"
    end
  end

  describe 'metrics' do
    it 'should have all keys' do
      Rack::ActionLogger.configure { |config| config.rack_request_blacklist = [] }
      metrics = target.metrics
      described_class::METRICS.each do |metric|
        expect(metrics).to have_key(metric)
      end
    end

    it 'should not have blacklist key' do
      blacklist_key = :path
      Rack::ActionLogger.configure do |config|
        config.rack_request_blacklist = [blacklist_key]
      end
      metrics = target.metrics
      described_class::METRICS.each do |metric|
        if metric == blacklist_key
          expect(metrics).not_to have_key(metric)
        else
          expect(metrics).to have_key(metric)
        end
      end
    end
  end

  describe 'path' do
    it do
      expect(target.path).to eq '/path/to'
    end
  end

  describe 'method' do
    it do
      expect(target.method).to eq 'GET'
    end
  end

  describe 'params' do
    it do
      expect(target.params).to eq({ 'key' => 'value' })
    end
  end

  describe 'request_headers' do
    it do
      expect(target.request_headers).to eq({ 'HTTP_USER_AGENT' => user_agent })
    end
  end

  describe 'remote_ip' do
    it do
      expect(target.ip).to eq ip
    end
  end

  describe 'user_agent' do
    it do
      expect(target.user_agent).to eq user_agent
    end
  end

  describe 'device' do
    it do
      expect(target.device).to eq :smartphone
    end
  end

  describe 'os' do
    it do
      expect(target.os).to eq 'iPad'
    end
  end


  describe 'browser' do
    it do
      expect(target.browser).to eq 'Safari'
    end
  end

  describe 'browser_version' do
    it do
      expect(target.browser_version).to eq '4.0.4'
    end
  end

  describe 'response_headers' do
    it do
      expect(target.response_headers).to eq response_header
    end
  end

  describe 'response_json_body' do
    it do
      expect(target.response_json_body).to eq({ 'key' => 'body' })
    end
  end

end
