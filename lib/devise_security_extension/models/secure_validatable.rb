require 'rails_email_validator'

module Devise
  module Models
    # SecureValidatable creates better validations with more validation for security
    #
    # == Options
    #
    # SecureValidatable adds the following options to devise_for:
    #
    #   * +email_regexp+: the regular expression used to validate e-mails;
    #   * +password_length+: a range expressing password length. Defaults from devise
    #   * +password_regex+: need strong password. Defaults to /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
    #
    module SecureValidatable

      def self.included(base)
        base.extend ClassMethods
        assert_secure_validations_api!(base)

        base.class_eval do

          # uniq login
          validates authentication_keys[0], :uniqueness => {:scope => authentication_keys[1..-1]}#, :case_sensitive => case_insensitive_keys.exclude?(authentication_keys[0])

          # validates email
          validates :email, :presence => true, :if => :email_required?
          validates :email, :email => true # use rails_email_validator

          # validates password
          validates :password, :presence => true, :length => password_length, :format => password_regex, :confirmation => true, :if => :password_required?
        end
      end

      def self.assert_secure_validations_api!(base) #:nodoc:
        raise "Could not use SecureValidatable on #{base}" unless base.respond_to?(:validates)
      end

      protected

      # Checks whether a password is needed or not. For validations only.
      # Passwords are always required if it's a new record, or if the password
      # or confirmation are being set somewhere.
      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end

      def email_required?
        true
      end

      module ClassMethods
        Devise::Models.config(self, :password_regex, :password_length)
      end
    end
  end
end
