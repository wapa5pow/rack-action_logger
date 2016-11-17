require "spec_helper"
require 'rack/test'

RSpec.describe Rack::ActionLogger::Context do
  include TestApplicationHelper
  include Rack::Test::Methods

  let(:test_app) { TestApplicationHelper::TestApplication.new }
  let(:app)      { described_class.new(test_app) }

  describe "GET '/hoge'" do
    it 'should return 200 OK' do
      get '/hoge'
      expect(last_response.status).to eq 200
    end
  end

end
