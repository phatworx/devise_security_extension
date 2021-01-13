module Devise
  module Models
    module DatabaseAuthenticatablePatch
      def update_with_password(params, *options)
        current_password = params.delete(:current_password)

        new_password = params[:password]
        new_password_confirmation = params[:password_confirmation]

        result = if valid_password?(current_password) && new_password.present? && new_password_confirmation.present? && new_password_confirmation == new_password
          update_attributes(params, *options)
        else
          self.assign_attributes(params, *options)
          self.valid?
          self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
          self.errors.add(:password, new_password.blank? ? :blank : :invalid)
          new_password_confirmation_error = if new_password_confirmation.blank?
                                              :blank
                                            elsif new_password != new_password_confirmation
                                              I18n.t('errors.messages.password_confirmation_mismatched')
                                            else
                                              :invalid
                                            end
          self.errors.add(:password_confirmation, new_password_confirmation_error)
          false
        end

        clean_up_passwords
        result
      end
    end
  end
end
