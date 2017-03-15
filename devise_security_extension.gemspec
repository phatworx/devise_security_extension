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

  s.files         = Dir["{lib,app,config}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.test_files    = Dir["{test}/**/*", "[A-Z]*"]
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.3.2'

  s.add_runtime_dependency 'railties', '>= 5.0.0.1', '< 5.1'
  s.add_runtime_dependency 'devise', '>= 4.2.0', '< 4.3'
  s.add_development_dependency 'bundler', '>= 1.3', '< 2.0'
  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.10'
  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'minitest','~> 5.9', '>= 5.9.1'
  s.add_development_dependency 'easy_captcha', '~> 0'
  s.add_development_dependency 'rails_email_validator', '~> 0'
end
