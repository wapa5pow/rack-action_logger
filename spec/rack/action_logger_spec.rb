require "spec_helper"

describe Rack::ActionLogger do
  it "has a version number" do
    expect(Rack::ActionLogger::VERSION).not_to be nil
  end
end
