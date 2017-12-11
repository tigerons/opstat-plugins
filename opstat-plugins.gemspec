# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opstat-plugins/version'

Gem::Specification.new do |s|
  s.name        = 'opstat-plugins'
  s.version     = Opstat::VERSION
  s.date        = '2017-06-13'
  s.summary     = "Opstat plugins"
  s.description = "All opstat plugins"
  s.authors     = ["Krzysztof Tomczyk"]
  s.email       = 'ktomczyk@power.com.pl'
  s.homepage    = 'http://rubygems.org/gems/opstat-plugins'
  s.license       = "GPL-3.0"
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_dependency "log4r", '~> 1'
end
