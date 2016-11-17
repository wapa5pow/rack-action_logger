require "spec_helper"

RSpec.describe Rack::ActionLogger::Configuration do
  describe 'tag_prefix' do
    it 'should be default tag prefix if nil' do
      Rack::ActionLogger.configure { |c| c.tag_prefix = nil }
      expect(Rack::ActionLogger.configuration.tag_prefix).to eq described_class::DEFAULT_TAG_PREFIX
    end

    it 'should be default tag prefix if empty' do
      Rack::ActionLogger.configure { |c| c.tag_prefix = '' }
      expect(Rack::ActionLogger.configuration.tag_prefix).to eq described_class::DEFAULT_TAG_PREFIX
    end

    it 'should be the tag' do
      Rack::ActionLogger.configure { |c| c.tag_prefix = 'tag' }
      expect(Rack::ActionLogger.configuration.tag_prefix).to eq 'tag'
    end
  end

  describe 'default_tag' do
    it 'should be the tag' do
      Rack::ActionLogger.configure { |c| c.tag_prefix = 'tag' }
      expect(Rack::ActionLogger.configuration.default_tag).to eq 'tag.log'
    end
  end
end
