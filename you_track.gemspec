# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'you_track/version'

Gem::Specification.new do |spec|
  spec.name          = "you_track"
  spec.version       = YouTrack::VERSION
  spec.authors       = ["Josh Lane"]
  spec.email         = ["me@joshualane.com"]

  spec.summary       = %q{YouTrack 6.x API Client}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/lanej/you_track.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "cistern",            "~> 2.0"
  spec.add_dependency "faraday-cookie_jar", "~> 0.0"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "faraday",            "~> 0.9"
  spec.add_dependency "multi_xml",          "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
