require 'rails/all'
require 'active_support/core_ext/integer'
require 'devise'

module Devise

  # expire password after e.g 1.year
  mattr_accessor :expire_password_after
  @@expire_password_after = 3.months

  module Models
    autoload :PasswordExpirable, 'devise_security_extension/models/password_expirable'
  end

  # security extension for enterprise environment
  module SecurityExtension
    autoload :Schema, 'devise_security_extension/schema'
    autoload :Engine, 'devise_security_extension/engine'

    class << self
      def init
        Devise::Schema.send :include, Devise::SecurityExtension::Schema
        Devise.add_module :password_expirable
      end
    end
  end
end

Devise::SecurityExtension.init