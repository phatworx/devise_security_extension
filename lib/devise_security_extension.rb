require 'rails/all'
require 'active_support/core_ext/integer'
require 'devise'
require 'devise_security_extension/routes'
require 'devise_security_extension/schema'
require 'devise_security_extension/controllers/helpers'
require 'devise_security_extension/rails'

module Devise # :nodoc:

  # expire password after e.g 1.year
  mattr_accessor :expire_password_after
  @@expire_password_after = false

end

# an security extension for devise
module DeviseSecurityExtension

end

Devise.add_module :password_expirable, :controller => :password_expirable, :model => 'devise_security_extension/models/password_expirable', :route => :password_expired
