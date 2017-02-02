# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/json_parser/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-json_parser'
  spec.version       = Rack::JSONParser::VERSION
  spec.authors       = ['Joakim Reinert']
  spec.email         = ['reinert@meso.net']

  spec.summary       = 'A tiny rack middleware for parsing json request bodies'
  spec.description   =
    'Provides a middleware for parsing json from request bodies to be ' \
    'accessed from request params'
  spec.homepage      = 'https://github.com/meso-unimpressed/rack-json_parser'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^spec/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.4'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.1'

  spec.add_dependency 'rack', '~> 2.0'
end
