require 'rubygems'
require 'bundler'
require 'rake/testtask'
require 'jeweler'
require 'rdoc/task'

desc 'Default: Run DeviseSecurityExtension unit tests'
task default: :test

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = 'devise_security_extension'
  gem.homepage = 'http://github.com/phatworx/devise_security_extension'
  gem.license = 'MIT'
  gem.summary = %(Security extension for devise)
  gem.description = %(An enterprise security extension for devise, trying to meet industrial standard security demands for web applications.)
  gem.email = 'team@phatworx.de'
  gem.authors = ['Marco Scholl', 'Alexander Dreher']
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
  t.warning = false
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "devise_security_extension #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
