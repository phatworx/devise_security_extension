module DeviseSecurityExtension
  module Patches
    autoload :UnlocksControllerCaptcha, 'devise_security_extension/patches/unlocks_controller_captcha'
    autoload :PasswordsControllerCaptcha, 'devise_security_extension/patches/passwords_controller_captcha'
    autoload :SessionsControllerCaptcha, 'devise_security_extension/patches/sessions_controller_captcha'
    autoload :RegistrationsControllerCaptcha, 'devise_security_extension/patches/registrations_controller_captcha'
    autoload :ConfirmationsControllerCaptcha, 'devise_security_extension/patches/confirmations_controller_captcha'
    
    class << self
      def apply
        Devise::PasswordsController.send(:include, Patches::PasswordsControllerCaptcha) if Devise.captcha_for_recover
        Devise::UnlocksController.send(:include, Patches::UnlocksControllerCaptcha) if Devise.captcha_for_unlock
        Devise::RegistrationsController.send(:include, Patches::RegistrationsControllerCaptcha) if Devise.captcha_for_sign_up
        Devise::SessionsController.send(:include, Patches::SessionsControllerCaptcha) if Devise.captcha_for_sign_in
        Devise::ConfirmationsController.send(:include, Patches::ConfirmationsControllerCaptcha) if Devise.captcha_for_confirmation
      end
    end
  end
end
