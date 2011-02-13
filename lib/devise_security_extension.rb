#require 'rails/all'
require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_support/core_ext/integer'
require 'active_support/ordered_hash'
require 'active_support/concern'
require 'devise'

module Devise # :nodoc:

  # expire password after e.g 1.year
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months

  # validate password for strongness
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/

  # write history of last x passwords
  mattr_accessor :password_archiving_count
  @@password_archiving_count = 5

  # deny old password (true, false, integer)
  mattr_accessor :deny_old_passwords
  @@deny_old_passwords = true
end

# an security extension for devise
module DeviseSecurityExtension
  autoload :Schema, 'devise_security_extension/schema'

  module Controllers # :nodoc:
    autoload :Helpers, 'devise_security_extension/controllers/helpers'
  end
end

Devise.add_module :password_expirable, :controller => :password_expirable, :model => 'devise_security_extension/models/password_expirable', :route => :password_expired
Devise.add_module :secure_validatable, :model => 'devise_security_extension/models/secure_validatable'
Devise.add_module :password_archivable, :model => 'devise_security_extension/models/password_archivable'

require 'devise_security_extension/routes'
require 'devise_security_extension/rails'
require 'devise_security_extension/orm/active_record'
require 'devise_security_extension/models/old_password'
