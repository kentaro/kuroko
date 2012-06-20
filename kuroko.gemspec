# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kuroko/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kentaro Kuribayashi"]
  gem.email         = ["kentarok@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "kuroko"
  gem.require_paths = ["lib"]
  gem.version       = Kuroko::VERSION

  gem.add_development_dependency 'cinch'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'feedzirra'
end
