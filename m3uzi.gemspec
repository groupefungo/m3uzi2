# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'm3uzi/version'

Gem::Specification.new do |s|
  s.name         = 'm3uzi2'
  s.version      = M3Uzi2::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Brandon Arbini', 'Justin Greer']
  s.email        = ['brandon@zencoder.com', 'justin@zencoder.com']
  s.homepage     = 'http://github.com/os6sense/m3uzi2'
  s.summary      = 'Read and write M3U files.'
  s.description  = 'Read and write M3U files.'
  s.files        = Dir.glob("lib/**/*") + Dir.glob("spec/**/*") + %w(LICENSE Rakefile README.md)
  s.require_path = 'lib'
end
