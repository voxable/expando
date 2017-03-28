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
  # Testing
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  # Formatting test results for Travis CI
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.2'
  # Measuring code coverage
  spec.add_development_dependency 'simplecov', '~> 0.13.0'
  # Push coverage results to Code Climate
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.8'
  # Code style checking
  spec.add_development_dependency 'rubocop', '~> 0.48'

  # API.ai integration
  spec.add_runtime_dependency 'voxable-api-ai-ruby', '~> 1.1.1'
  # CLI framework
  spec.add_runtime_dependency 'gli', '~> 2.16.0'
  # Colorizing output for CLI (TODO: drop for pastel)
  spec.add_runtime_dependency 'colorize', '~> 0.8.1'
  # Pretty-printing hashes for CLI
  spec.add_runtime_dependency 'awesome_print', '~> 1.7.0'
  # Parsing arbitrary front-matter metadata for CLI
  spec.add_runtime_dependency 'front_matter_parser', '~> 0.0.4'
  # Outputting intent lists for CLI
  spec.add_runtime_dependency 'tty-table', '~> 0.8.0'
  # dry-rb framework
  spec.add_runtime_dependency 'dry-initializer', '~> 1.3.0'
  spec.add_runtime_dependency 'dry-types', '0.9.4'
end
