# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hoboku/version'

Gem::Specification.new do |gem|
  gem.name          = "hoboku"
  gem.version       = Hoboku::VERSION
  gem.authors       = ["Isaac Wolkerstorfer"]
  gem.email         = ["i@agnoster.net"]
  gem.description   = %q{Deploy apps locally to Vagrant, Heroku-style.}
  gem.summary       = %q{Hoboku is a tool to easily deploy Heroku apps locally using Vagrant, to achieve dev-prod parity.}
  gem.homepage      = "https://github.com/agnoster/hoboku"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
