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
        if self.class.expire_password_after.is_a? Fixnum or self.class.expire_password_after.is_a? Float
          self.password_changed_at.nil? or self.password_changed_at < self.class.expire_password_after.ago
        else
          false
        end
      end

      # set a fake datetime so a password change is needed and save the record
      def need_change_password!
        if self.class.expire_password_after.is_a?(Numeric)
          update_column :password_changed_at, self.class.expire_password_after.ago
        end
        password_changed_at
      end

      # set a fake datetime so a password change is needed
      def need_change_password
        if self.class.expire_password_after.is_a?(Numeric)
          password_changed_at = self.class.expire_password_after.ago
        end
        password_changed_at
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
