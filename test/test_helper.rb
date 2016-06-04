ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear!

require 'dummy/config/environment'
require 'minitest/autorun'
require 'rails/test_help'
require 'devise_security_extension'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Migrator.migrate(File.expand_path('../dummy/db/migrate', __FILE__))
