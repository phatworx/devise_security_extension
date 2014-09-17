require 'devise_security_extension/hooks/password_expirable'

module Devise
  module Models

    # PasswordExpirable takes care of change password after
    module PasswordExpirable
      extend ActiveSupport::Concern

      included do
        before_save :update_password_changed
      end

      def password_needs_reset?
        self.class.has_expire_password_configuration? &&
          password_has_expired?
      end

      def force_password_expire
        if self.class.has_expire_password_configuration?
          self.password_changed_at = self.class.expire_password_after.ago
        end

        return password_changed_at
      end

      def force_password_expire!
        if self.class.has_expire_password_configuration?
          force_password_expire
          save validate: false
        end
      end

      def update_password(params, *options)
        current_password = params.delete :current_password
        password_params = params.slice :password, :password_confirmation
        password_errors = {}

        unless valid_password? current_password
          password_errors[:current_password] = current_password.blank? ? :blank : :invalid
          log_failed_access_attempt
        end

        if password_errors[:current_password].nil? && current_password == password_params[:password] &&
          password_errors[:password] = :must_be_different
        end

        result = if password_errors.any?
                   self.assign_attributes(password_params, *options)
                   self.valid?
                   password_errors.each { |attr, msg| self.errors.add(attr, msg) }
                   false
                 else
                   update_attributes(password_params, *options)
                 end

        clean_up_passwords
        result
      end

      private
      def password_has_expired?
        self.password_changed_at.nil? ||
          self.password_changed_at < self.class.expire_password_after.ago
      end

      def update_password_changed
        if (new_record? || encrypted_password_changed?) &&
          !password_changed_at_changed?
          self.password_changed_at = Time.now
        end
      end

      def log_failed_access_attempt
        if respond_to?(:failed_attempts) && !access_locked?
          reload
          self.failed_attempts ||= 0
          self.failed_attempts += 1
          if attempts_exceeded?
            lock_access! unless access_locked?
          else
            save(validate: false)
          end
        end
      end

      module ClassMethods
        def has_expire_password_configuration?
          expire_password_after.is_a?(Fixnum) ||
            expire_password_after.is_a?(Float)
        end

        ::Devise::Models.config(self, :expire_password_after)
      end

    end

  end

end
