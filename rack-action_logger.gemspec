# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/action_logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-action_logger'
  spec.version       = Rack::ActionLogger::VERSION
  spec.authors       = ['Koichi Ishida']
  spec.email         = ['wapa5pow@gmail.com']

  spec.summary       = 'Rack::ActionLogger is a tool to log user activity'
  spec.description   = 'Rack::ActionLogger is a tool to log user activity'
  spec.homepage      = 'https://github.com/wapa5pow/rack-action_logger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|docs|example)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'fluent-logger', '~> 0.5'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
