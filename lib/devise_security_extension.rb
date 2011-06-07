#require 'rails/all'
require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_support/core_ext/integer'
require 'active_support/ordered_hash'
require 'active_support/concern'
require 'devise'

module Devise # :nodoc:  

  # Should the password expire (e.g 3.months)
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months

  # Validate password for strongness
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/

  # How often save old passwords in archive
  mattr_accessor :password_archiving_count
  @@password_archiving_count = 5

  # Deny old password (true, false, count)
  mattr_accessor :deny_old_passwords
  @@deny_old_passwords = true

  # enable email validation for :secure_validatable. (true, false, validation_options)
  # dependency: need an email validator like rails_email_validator
  mattr_accessor :email_validation
  @@email_validation = true
  
  # captcha integration for recover form
  mattr_accessor :recover_captcha
  @@recover_captcha = false
  
  # captcha integration for sign up form
  mattr_accessor :sign_up_captcha
  @@sign_up_captcha = false
  
  # captcha integration for sign in form
  mattr_accessor :sign_in_captcha
  @@sign_in_captcha = false
  
  # captcha integration for unlock form
  mattr_accessor :unlock_captcha
  @@unlock_captcha = false
  
end

# an security extension for devise
module DeviseSecurityExtension
  autoload :Schema, 'devise_security_extension/schema'
  autoload :Patches, 'devise_security_extension/patches'

  module Controllers # :nodoc:
    autoload :Helpers, 'devise_security_extension/controllers/helpers'
  end
end

# modules
Devise.add_module :password_expirable, :controller => :password_expirable, :model => 'devise_security_extension/models/password_expirable', :route => :password_expired
Devise.add_module :secure_validatable, :model => 'devise_security_extension/models/secure_validatable'
Devise.add_module :password_archivable, :model => 'devise_security_extension/models/password_archivable'

# requires
require 'devise_security_extension/routes'
require 'devise_security_extension/rails'
require 'devise_security_extension/orm/active_record'
require 'devise_security_extension/models/old_password'

