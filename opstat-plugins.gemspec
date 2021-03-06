Gem::Specification.new do |s|
  s.name        = 'opstat-plugins'
  s.version     = '0.0.3'
  s.date        = '2014-12-12'
  s.summary     = "Opstat plugins"
  s.description = "All opstat plugins"
  s.authors     = ["Krzysztof Tomczyk"]
  s.email       = 'ktomczyk@power.com.pl'
  s.homepage    = 'http://rubygems.org/gems/opstat-plugins'
  s.license       = "GPL-3"
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
