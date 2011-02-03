#require 'rails/all'
require 'active_record/connection_adapters/abstract/schema_definitions'
require 'active_support/core_ext/integer'
require 'devise'

module Devise # :nodoc:

  # expire password after e.g 1.year
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months

  # validate password for strongness
  mattr_accessor :password_regex
  @@password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/

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

require 'devise_security_extension/routes'
require 'devise_security_extension/rails'
require 'devise_security_extension/orm/active_record'
