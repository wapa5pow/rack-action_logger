require 'simplecov'
require 'codeclimate-test-reporter'

dir = File.join(ENV['CIRCLE_ARTIFACTS'] || 'build', 'coverage')
SimpleCov.coverage_dir(dir)

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/example/'
  add_filter '/docs/'

  add_group 'lib', 'lib'

  if ENV['CI']
    formatter SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      CodeClimate::TestReporter::Formatter
    ]
  end

end
