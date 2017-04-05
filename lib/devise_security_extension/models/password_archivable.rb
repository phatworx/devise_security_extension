module Devise
  module Models
    # PasswordArchivable
    module PasswordArchivable
      extend ActiveSupport::Concern

      included do
        has_many :old_passwords, as: :password_archivable, dependent: :destroy
        before_update :archive_password
        validate :validate_password_archive
      end

      def validate_password_archive
        errors.add(:password, :taken_in_past) if encrypted_password_changed? and password_archive_included?
      end

      # validate is the password used in the past
      def password_archive_included?
        unless deny_old_passwords.is_a? 1.class
          if deny_old_passwords.is_a? TrueClass and archive_count > 0
            self.deny_old_passwords = archive_count
          else
            self.deny_old_passwords = 0
          end
        end

        if self.class.deny_old_passwords > 0 and not self.password.nil?
          old_passwords_including_cur_change = self.old_passwords.order(:id).reverse_order.limit(self.class.deny_old_passwords).to_a
          old_passwords_including_cur_change << OldPassword.new(old_password_params)  # include most recent change in list, but don't save it yet!
          old_passwords_including_cur_change.each do |old_password|
            dummy                    = self.class.new
            dummy.encrypted_password = old_password.encrypted_password
            return true if dummy.valid_password?(password)
          end
        end

        false
      end

      def password_changed_to_same?
        pass_change = encrypted_password_change
        pass_change && pass_change.first == pass_change.last
      end

      def deny_old_passwords
        self.class.deny_old_passwords
      end

      def deny_old_passwords=(count)
        self.class.deny_old_passwords = count
      end

      def archive_count
        self.class.password_archiving_count
      end

      private

      # archive the last password before save and delete all to old passwords from archive
      def archive_password
        if encrypted_password_changed?
          if archive_count.to_i > 0
            old_passwords.create! old_password_params
            old_passwords.order(:id).reverse_order.offset(archive_count).destroy_all
          else
            old_passwords.destroy_all
          end
        end
      end

      def old_password_params
        { encrypted_password: encrypted_password_change.first }
      end

      module ClassMethods
        ::Devise::Models.config(self, :password_archiving_count, :deny_old_passwords)
      end
    end
  end
end
