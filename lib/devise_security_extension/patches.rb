module DeviseSecurityExtension
  module Patches
    autoload :UnlocksControllerSecurityQuestion, 'devise_security_extension/patches/unlocks_controller_security_question'
    autoload :PasswordsControllerSecurityQuestion, 'devise_security_extension/patches/passwords_controller_security_question'
    autoload :ConfirmationsControllerSecurityQuestion, 'devise_security_extension/patches/confirmations_controller_security_question'
    autoload :UnlocksControllerCaptcha, 'devise_security_extension/patches/unlocks_controller_captcha'
    autoload :PasswordsControllerCaptcha, 'devise_security_extension/patches/passwords_controller_captcha'
    autoload :SessionsControllerCaptcha, 'devise_security_extension/patches/sessions_controller_captcha'
    autoload :RegistrationsControllerCaptcha, 'devise_security_extension/patches/registrations_controller_captcha'
    autoload :ConfirmationsControllerCaptcha, 'devise_security_extension/patches/confirmations_controller_captcha'

    class << self
      def apply
        Devise::PasswordsController.send(:include, Patches::PasswordsControllerCaptcha) if Devise.captcha_for_recover or Devise.security_question_for_recover
        Devise::UnlocksController.send(:include, Patches::UnlocksControllerCaptcha) if Devise.captcha_for_unlock or Devise.security_question_for_unlock
        Devise::ConfirmationsController.send(:include, Patches::ConfirmationsControllerCaptcha) if Devise.captcha_for_confirmation

        Devise::PasswordsController.send(:include, Patches::PasswordsControllerSecurityQuestion) if Devise.security_question_for_recover
        Devise::UnlocksController.send(:include, Patches::UnlocksControllerSecurityQuestion) if Devise.security_question_for_unlock
        Devise::ConfirmationsController.send(:include, Patches::ConfirmationsControllerSecurityQuestion) if Devise.security_question_for_confirmation

        Devise::RegistrationsController.send(:include, Patches::RegistrationsControllerCaptcha) if Devise.captcha_for_sign_up
        Devise::SessionsController.send(:include, Patches::SessionsControllerCaptcha) if Devise.captcha_for_sign_in
      end
    end
  end
end
