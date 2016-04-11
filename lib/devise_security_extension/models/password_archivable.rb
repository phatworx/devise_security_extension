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
        unless deny_old_passwords.is_a? Fixnum
          if deny_old_passwords.is_a? TrueClass and archive_count > 0
            self.deny_old_passwords = archive_count
          else
            self.deny_old_passwords = 0
          end
        end

        if deny_old_passwords > 0 and !password.nil?
          old_passwords_including_cur_change = old_passwords_to_be_denied.all
          old_passwords_including_cur_change << OldPassword.new(old_password_params) # include most recent change in list, but don't save it yet!
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

      def deny_newer_password_than
        self.class.deny_newer_password_than.to_i
      end

      private

      def old_passwords_to_be_denied
        if deny_newer_password_than > 0
          rel = old_passwords.where("created_at > ?", Time.now - deny_newer_password_than)
          # if there are more archived passwords within the configured timeframe
          # than what you would otherwise deny take that list.
          return rel if rel.count > deny_old_passwords
        end
        # less passwords were found, use default last X passwords to be denied.
        old_passwords.order(:id).reverse_order.limit(deny_old_passwords)
      end

      # archive the last password before save and delete all too old passwords from archive
      def archive_password
        if encrypted_password_changed?
          if archive_count.to_i > 0 or deny_newer_password_than > 0
            count = [old_passwords_to_be_denied.count, archive_count].max
            old_passwords.create! old_password_params
            old_passwords.order(:id).reverse_order.offset(count).destroy_all
          else
            old_passwords.destroy_all
          end
        end
      end

      def old_password_params
        { encrypted_password: encrypted_password_change.first, created_at: Time.now }
      end

      module ClassMethods
        ::Devise::Models.config(self,
          :password_archiving_count,
          :deny_old_passwords,
          :deny_newer_password_than)
      end
    end
  end
end
