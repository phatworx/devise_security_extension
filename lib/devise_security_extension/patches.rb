module DeviseSecurityExtension
  module Patches
    autoload :ControllerCaptcha, 'devise_security_extension/patches/controller_captcha'
    autoload :ControllerSecurityQuestion, 'devise_security_extension/patches/controller_security_question'

    class << self
      def apply
        Devise::PasswordsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_recover || Devise.security_question_for_recover
        Devise::UnlocksController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_unlock || Devise.security_question_for_unlock
        Devise::ConfirmationsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_confirmation

        Devise::PasswordsController.send(:include, Patches::ControllerSecurityQuestion) if Devise.security_question_for_recover
        Devise::UnlocksController.send(:include, Patches::ControllerSecurityQuestion) if Devise.security_question_for_unlock
        Devise::ConfirmationsController.send(:include, Patches::ControllerSecurityQuestion) if Devise.security_question_for_confirmation

        Devise::RegistrationsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_sign_up
        Devise::SessionsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_sign_in
      end
    end
  end
end
