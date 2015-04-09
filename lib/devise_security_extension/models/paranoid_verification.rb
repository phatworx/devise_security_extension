require 'devise_security_extension/hooks/paranoid_verification'

module Devise
  module Models
    # PasswordExpirable takes care of change password after
    module ParanoidVerification
      extend ActiveSupport::Concern

      def need_paranoid_verification?
        !!paranoid_verification_code
      end

      def verify_code(code)
        attempt = paranoid_verification_attempt

        if (attempt += 1) >= Devise.paranoid_code_regenerate_after_attempt
          generate_paranoid_code
        elsif code == paranoid_verification_code
          attempt = 0
          update_without_password paranoid_verification_code: nil, paranoid_verified_at: Time.now, paranoid_verification_attempt: attempt
        else
          update_without_password paranoid_verification_attempt: attempt
        end
      end

      def paranoid_attempts_remaining
        Devise.paranoid_code_regenerate_after_attempt - paranoid_verification_attempt
      end

      def generate_paranoid_code
        update_without_password paranoid_verification_code: Devise.verification_code_generator.call(), paranoid_verification_attempt: 0
      end
    end
  end
end
