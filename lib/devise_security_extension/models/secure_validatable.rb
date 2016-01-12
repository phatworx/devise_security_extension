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
          already_validated_email = false

          # validate login in a strict way if not yet validated
          unless has_uniqueness_validation_of_login?
            validation_condition = "#{login_attribute}_changed?".to_sym

            validates login_attribute, :uniqueness => {
                                          :scope          => authentication_keys[1..-1],
                                          :case_sensitive => !!case_insensitive_keys
                                        },
                                        :if => validation_condition

            already_validated_email = login_attribute.to_s == 'email'
          end

          unless devise_validation_enabled?
            validates :email, :presence => true, :if => :email_required?
            unless already_validated_email
              validates :email, :uniqueness => true, :allow_blank => true, :if => :email_changed? # check uniq for email ever
            end

            validates :password, :presence => true, :length => password_length, :confirmation => true, :if => :password_required?
          end

          # extra validations
          validates :email,    :email  => email_validation if email_validation # use rails_email_validator or similar
          validates :password, :format => { :with => password_regex, :message => :password_format }, :if => :password_required?

          # don't allow use same password
          validate :current_equal_password_validation
        end
      end

      def self.assert_secure_validations_api!(base)
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

      private
        def has_uniqueness_validation_of_login?
          validators.any? do |validator|
            validator.kind_of?(ActiveRecord::Validations::UniquenessValidator) &&
              validator.attributes.include?(login_attribute)
          end
        end

        def login_attribute
          authentication_keys[0]
        end

        def devise_validation_enabled?
          self.ancestors.map(&:to_s).include? 'Devise::Models::Validatable'
        end
      end
    end
  end
end
