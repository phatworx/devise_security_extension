module DeviseSecurityExtension::Patches
  module ControllerCaptcha
    extend ActiveSupport::Concern

    included do
      append_before_action :check_captcha, only: [:create]
    end

    private
    def check_captcha
      build_resource(sign_up_params)

     if ((defined? verify_recaptcha) && (verify_recaptcha)) || ((defined? valid_captcha?) && (valid_captcha? params[:captcha]))
      resource.errors.add :base, t('devise.invalid_captcha')
       return resource
     end
      flash[:alert] = t('devise.invalid_captcha') if is_navigational_format?
      respond_with({}, location: url_for(action: :new))
    end
  end
end
