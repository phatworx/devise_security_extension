require 'devise_security_extension/hooks/password_expirable'

module Devise
  module Models

    # PasswordExpirable takes care of change password after
    module PasswordExpirable
      extend ActiveSupport::Concern

      included do
        before_save :update_password_changed
      end

      # is an password change required?
      def need_change_password?
        if self.expire_password_after.is_a? Integer or self.expire_password_after.is_a? Float
          self.password_changed_at.nil? or self.password_changed_at < self.expire_password_after.seconds.ago
        else
          false
        end
      end

      # set a fake datetime so a password change is needed and save the record
      def need_change_password!
        if self.expire_password_after.is_a? Integer or self.expire_password_after.is_a? Float
          need_change_password
          self.save(:validate => false)
        end
      end

      # set a fake datetime so a password change is needed
      def need_change_password
        if self.expire_password_after.is_a? Integer or self.expire_password_after.is_a? Float
          self.password_changed_at = self.expire_password_after.seconds.ago
        end

        # is date not set it will set default to need set new password next login
        need_change_password if self.password_changed_at.nil?

        self.password_changed_at
      end
      
      def expire_password_after
        self.class.expire_password_after
      end

      private

        # is password changed then update password_cahanged_at
        def update_password_changed
          self.password_changed_at = Time.now if (self.new_record? or self.encrypted_password_changed?) and not self.password_changed_at_changed?
        end

      module ClassMethods
        ::Devise::Models.config(self, :expire_password_after)
      end
    end

  end

end
