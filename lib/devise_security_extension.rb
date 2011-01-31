require 'rails/all'
require 'active_support/core_ext/integer'
require 'devise'
require 'devise_security_extension/routes'
require 'devise_security_extension/schema'
require 'devise_security_extension/controllers/helpers'
require 'devise_security_extension/rails'

module Devise

  # expire password after e.g 1.year
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months

#  module Models
#    autoload :PasswordExpirable, 'devise_security_extension/models/password_expirable'
#  end

  # security extension for enterprise environment
  #module SecurityExtension

   # module Controllers
    #  autoload :Helpers, 'devise_security_extension/controllers/helpers'
    #  autoload :PasswordController, 'devise_security_extension/controllers/password_controller'
    #end

  #end
end

Devise.add_module :password_expirable, :controller => :password_expirable, :model => 'devise_security_extension/models/password_expirable', :route => :password_expired
