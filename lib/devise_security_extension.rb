#require 'rails/all'
require 'active_record/connection_adapters/abstract/schema_definitions' if defined?(ActiveRecord)
require 'active_support/core_ext/integer'
require 'active_support/ordered_hash'
require 'active_support/concern'
require 'devise'

module Devise

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
  mattr_accessor :captcha_for_recover
  @@captcha_for_recover = false

  # captcha integration for sign up form
  mattr_accessor :captcha_for_sign_up
  @@captcha_for_sign_up = false

  # captcha integration for sign in form
  mattr_accessor :captcha_for_sign_in
  @@captcha_for_sign_in = false

  # captcha integration for unlock form
  mattr_accessor :captcha_for_unlock
  @@captcha_for_unlock = false

  # security_question integration for recover form
  # this automatically enables captchas (captcha_for_recover, as fallback)
  mattr_accessor :security_question_for_recover
  @@security_question_for_recover = false

  # security_question integration for unlock form
  # this automatically enables captchas (captcha_for_unlock, as fallback)
  mattr_accessor :security_question_for_unlock
  @@security_question_for_unlock = false

  # security_question integration for confirmation form
  # this automatically enables captchas (captcha_for_confirmation, as fallback)
  mattr_accessor :security_question_for_confirmation
  @@security_question_for_confirmation = false

  # captcha integration for confirmation form
  mattr_accessor :captcha_for_confirmation
  @@captcha_for_confirmation = false

  # Time period for account expiry from last_activity_at
  mattr_accessor :expire_after
  @@expire_after = 90.days
  mattr_accessor :delete_expired_after
  @@delete_expired_after = 90.days
end

# an security extension for devise
module DeviseSecurityExtension
  autoload :Schema, 'devise_security_extension/schema'
  autoload :Patches, 'devise_security_extension/patches'

  module Controllers
    autoload :Helpers, 'devise_security_extension/controllers/helpers'
  end
end

orm = defined?(Mongoid) ? 'mongoid' : 'active_record'

# modules
Devise.add_module :password_expirable, :controller => :password_expirable, :model => 'devise_security_extension/models/password_expirable', :route => :password_expired
Devise.add_module :secure_validatable, :model => 'devise_security_extension/models/secure_validatable'
Devise.add_module :password_archivable, :model => 'devise_security_extension/models/password_archivable'
Devise.add_module :session_limitable, :model => 'devise_security_extension/models/session_limitable'
Devise.add_module :expirable, :model => 'devise_security_extension/models/expirable'
Devise.add_module :security_questionable, :model => 'devise_security_extension/models/security_questionable'

# requires
require 'devise_security_extension/routes'
require 'devise_security_extension/rails'
require 'devise_security_extension/orm/active_record' if defined?(ActiveRecord)
require "devise_security_extension/models/#{orm}/old_password"
require "devise_security_extension/models/#{orm}/security_question"
