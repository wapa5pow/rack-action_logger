SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'

  add_group 'lib', 'lib'

  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end
