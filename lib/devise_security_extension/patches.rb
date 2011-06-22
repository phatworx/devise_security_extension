module DeviseSecurityExtension
  module Patches
    autoload :ControllerCaptcha, 'devise_security_extension/patches/controller_captcha'
    
    class << self
      def apply
        Devise::PasswordsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_recover
        Devise::UnlocksController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_unlock
        Devise::RegistrationsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_sign_up
        Devise::SessionsController.send(:include, Patches::ControllerCaptcha) if Devise.captcha_for_sign_in
      end
    end
  end
end
