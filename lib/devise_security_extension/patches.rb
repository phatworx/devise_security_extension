module DeviseSecurityExtension
  module Patches
    autoload :ControllerCaptcha, 'devise_security_extension/patches/controller_captcha'
    
    class << self
      def apply
        Devise::PasswordsController.send(:include, Patches::ControllerCaptcha) if Devise.recover_captcha
        Devise::UnlocksController.send(:include, Patches::ControllerCaptcha) if Devise.unlock_captcha
        Devise::RegistrationsController.send(:include, Patches::ControllerCaptcha) if Devise.sign_up_captcha
        Devise::SessionsController.send(:include, Patches::ControllerCaptcha) if Devise.sign_in_captcha
      end
    end
  end
end
