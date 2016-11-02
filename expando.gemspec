# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expando/version'

Gem::Specification.new do |spec|
  spec.name          = 'expando'
  spec.version       = Expando::VERSION
  spec.authors       = ['Matt Buck']
  spec.email         = ['matt@voxable.io']

  spec.summary       = 'The Expando reference implementation.'
  spec.description   = 'A translation language for defining user utterance examples in conversational interfaces.'
  spec.homepage      = 'http://voxable.io'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.2'
  spec.add_development_dependency 'climate_control', '~> 0.0.3'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0.pre.rc2'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'

  spec.add_runtime_dependency 'voxable-api-ai-ruby', '~> 1.1.0'
  spec.add_runtime_dependency 'gli', '~> 2.14.0'
  spec.add_runtime_dependency 'colorize', '~> 0.8.1'
  spec.add_runtime_dependency 'awesome_print', '~> 1.7.0'
end
