# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'catalog/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'catalog-api-client'
  spec.version       = Catalog::Api::VERSION
  spec.authors       = ['Santosh Natarajan', 'Dave Donahue']
  spec.email         = ['snatarajan@instructure.com', 'ddonahue@instructure.com']

  spec.summary       = %q{ Ruby client for catalog api }
  spec.description   = %q{ Ruby client for catalog api }
  spec.homepage      = 'TODO: github website'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_dependency 'link_header'
  spec.add_dependency 'rest-client'
end
