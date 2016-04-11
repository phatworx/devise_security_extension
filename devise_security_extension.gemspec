# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'devise_security_extension/version'

Gem::Specification.new do |s|
  s.name = 'devise_security_extension'
  s.version     = DeviseSecurityExtension::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.summary     = 'Security extension for devise'
  s.email       = 'team@phatworx.de'
  s.homepage    = 'https://github.com/phatworx/devise_security_extension'
  s.description = 'An enterprise security extension for devise, trying to meet industrial standard security demands for web applications.'
  s.authors     = ['Marco Scholl', 'Alexander Dreher']

  s.rubyforge_project = 'devise_security_extension'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'railties', '>= 3.2.6', '< 5.0'
  s.add_runtime_dependency 'devise', '>= 3.0.0', '< 4.0'
  s.add_development_dependency 'bundler', '>= 1.3.0', '< 2.0'
  s.add_development_dependency 'sqlite3', '~> 1.3.10'
  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'easy_captcha', '~> 0'
  s.add_development_dependency 'rails_email_validator', '~> 0'
end
