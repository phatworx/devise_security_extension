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
        if code == paranoid_verification_code
          update_without_password paranoid_verification_code: nil, paranoid_verified_at: Time.now
        end
      end

      def generate_paranoid_code
        update_without_password paranoid_verification_code: Devise.verification_code_generator.call()
      end
    end
  end
end
