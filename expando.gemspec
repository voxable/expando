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

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.2'
  spec.add_development_dependency 'climate_control', '~> 0.0.3'

  spec.add_runtime_dependency 'api-ai-ruby', '~> 1.1.0'
  spec.add_runtime_dependency 'gli', '~> 2.13.4'
  spec.add_runtime_dependency 'colorize', '~> 0.7.7'
  spec.add_runtime_dependency 'awesome_print', '~> 1.6.1'
end
