require 'devise_security_extension/hooks/password_expirable'

module Devise
  module Models

    # PasswordExpirable takes care of change password afther
    module PasswordExpirable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          before_save :update_password_changed
          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:

        # is an password change required?
        def password_change_required?
          if self.class.expire_password_after.is_a? Fixnum
            self.password_changed_at.nil? or self.password_changed_at < self.class.expire_password_after.ago
          else
            false
          end
        end

        # set a fake datetime so a password change is needed and save the record
        def need_change_password!
          if self.class.expire_password_after.is_a? Fixnum
            need_change_password
            self.save(:validate => false)
          end
        end

        # set a fake datetime so a password change is needed
        def need_change_password
          if self.class.expire_password_after.is_a? Fixnum
            self.password_changed_at = self.class.expire_password_after.ago
          end

          # is date not set it will set default to need set new password next login
          need_change_password if self.password_changed_at.nil?

          self.password_changed_at
        end

        private

        # is password changed then update password_cahanged_at
        def update_password_changed
          self.password_changed_at = Time.now if (self.new_record? or self.encrypted_password_changed?) and not self.password_changed_at_changed?
        end
      end

      module ClassMethods #:nodoc:
        ::Devise::Models.config(self, :expire_password_after)
      end
    end
  end

end
