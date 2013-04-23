module Devise
  module Models
    module DatabaseAuthenticatablePatch
      def update_with_password(params, *options)
        current_password = params.delete(:current_password)

        new_password = params[:password]
        new_password_confirmation = params[:password_confirmation]

        result = if valid_password?(current_password) && new_password.present? && new_password_confirmation.present?
          update_attributes(params, *options)
        else
          self.assign_attributes(params, *options)
          self.valid?
          self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
          self.errors.add(:password, new_password.blank? ? :blank : :invalid)
          self.errors.add(:password_confirmation, new_password_confirmation.blank? ? :blank : :invalid)
          false
        end

        clean_up_passwords
        result
      end
    end
  end
end
