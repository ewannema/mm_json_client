# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mm_json_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'mm_json_client'
  spec.version       = MmJsonClient::VERSION
  spec.authors       = ['Eric Wannemacher']
  spec.email         = ['eric@wannemacher.us']

  spec.summary       = 'A client gem for Men & Mice IPAM via JSON-RPC'
  spec.homepage      = 'https://github.com/ewannema/mm_json_client'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Force listen (required by guard) to be a Ruby 2.0.0 compatible version.
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'listen', '~> 2.0'

  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  # Wasabi requires httpi which requires rack which is pulling 2.0+ and breaks
  # on < 2.2 Rubies. We will require a compatible rack for now and come back
  # to check on https://github.com/bundler/bundler/pull/4650
  spec.add_development_dependency 'wasabi'
  spec.add_development_dependency 'rack', '~>1.6'
end
