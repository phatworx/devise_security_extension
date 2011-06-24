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
          validates authentication_keys[0], :uniqueness => {:scope => authentication_keys[1..-1], :case_sensitive => (case_insensitive_keys != false)}, :if => :email_changed?

          # validates email
          validates :email, :presence => true, :if => :email_required?
          validates :email, :email => email_validation if email_validation # use rails_email_validator or similar
          
          # validates password
          validates :password, :presence => true, :length => password_length, :format => password_regex, :confirmation => true, :if => :password_required?

          # don't allow use same password
          validate :current_equal_password_validation
        end
      end

      def self.assert_secure_validations_api!(base) #:nodoc:
        raise "Could not use SecureValidatable on #{base}" unless base.respond_to?(:validates)
      end

      def current_equal_password_validation
        if not self.new_record? and not self.encrypted_password_change.nil?
          dummy = self.class.new
          dummy.encrypted_password = self.encrypted_password_change.first
          dummy.password_salt = self.password_salt_change.first if self.respond_to? :password_salt_change and not self.password_salt_change.nil?
          self.errors.add(:password, :equal_to_current_password) if dummy.valid_password?(self.password)
        end
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
        Devise::Models.config(self, :password_regex, :password_length, :email_validation)
      end
    end
  end
end
