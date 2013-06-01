# -*- encoding: utf-8 -*-
require './lib/version'

$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "tomcat-manager"
  s.version     = TomcatManager::VERSION
  s.authors     = ["Sunggun Yu"]
  s.email       = ["sunggun.dev@gmail.com"]
  s.homepage    = "https://github.com/sunggun-yu/capistrano-tomcat-manager"
  s.summary     = %q{Capistrano Recipe for Tomcat Manager}
  s.description = %q{Capistrano Recipe for Tomcat Manager}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('capistrano', '~>2.9')
  s.add_development_dependency('rake', '~>0.9.2')
end