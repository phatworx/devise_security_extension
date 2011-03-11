module Devise # :nodoc:
  module Models # :nodoc:

    # PasswordArchivable
    module PasswordArchivable

      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          include InstanceMethods
          has_many :old_passwords, :as => :password_archivable, :dependent => :destroy
          before_update :archive_password
          validate :validate_password_archive
        end
      end

      module InstanceMethods # :nodoc:

        def validate_password_archive
          self.errors.add(:password, :taken_in_past) if password_archive_included?
        end

        # validate is the password used in the past
        def password_archive_included?
          unless self.class.deny_old_passwords.is_a? Fixnum
            if self.class.deny_old_passwords.is_a? TrueClass and self.class.password_archiving_count > 0
              self.class.deny_old_passwords = self.class.password_archiving_count
            else
              self.class.deny_old_passwords = 0
            end
          end

          if self.class.deny_old_passwords > 0 and not self.password.nil?
            self.old_passwords.order('created_at DESC').limit(self.class.deny_old_passwords).limit(self.class.deny_old_passwords).each do |old_password|
              dummy                    = self.class.new
              dummy.encrypted_password = old_password.encrypted_password
              dummy.password_salt      = old_password.password_salt
              return true if dummy.valid_password?(self.password)
            end
          end

          false
        end

        private

        # archive the last password before save and delete all to old passwords from archive
        def archive_password
          if self.encrypted_password_changed?
            if self.class.password_archiving_count.to_i > 0
              self.old_passwords.create! :encrypted_password => self.encrypted_password_change.first, :password_salt => self.password_salt_change.first
              self.old_passwords.order('created_at DESC').offset(self.class.password_archiving_count).destroy_all
            else
              self.old_passwords.destroy_all
            end
          end
        end
      end

      module ClassMethods #:nodoc:
        ::Devise::Models.config(self, :password_archiving_count, :deny_old_passwords)
      end
    end
  end

end
