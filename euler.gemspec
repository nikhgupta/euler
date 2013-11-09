# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'euler/version'

Gem::Specification.new do |s| 
  s.name        = 'euler'
  s.version     = Euler::VERSION
  s.author      = 'Nikhil Gupta'
  s.email       = 'me@nikhgupta.com'
  s.homepage    = 'http://nikhgupta.com'
  s.license     = "MIT"
  s.platform    = Gem::Platform::RUBY
  # s.description = %q{TODO: Write a gem description}
  s.summary     = 'Easily solve ProjectEuler problems in Ruby'
  s.files       = `git ls-files`.split($\)
  s.bindir      = 'bin'
  s.files       = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths << 'lib'

  s.add_dependency 'thor'
  s.add_dependency 'mechanize'
  s.add_dependency 'loofah'
  s.add_dependency 'user_config'
  # s.add_dependency 'hirb'

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'aruba'
end
