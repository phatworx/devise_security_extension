class Captcha::SessionsController < Devise::SessionsController
  include DeviseSecurityExtension::Patches::ControllerCaptcha
end
