module DeviseSecurityExtension::Patches
  module UnlocksControllerCaptcha
    extend ActiveSupport::Concern
    included do
      define_method :create do
        if ((defined? verify_recaptcha) && (verify_recaptcha
        params[:captcha])) or ((defined? valid_captcha?) && (valid_captcha?
        params[:captcha]))
          self.resource = resource_class.send_unlock_instructions(params[resource_name])
          if successfully_sent?(resource)
            respond_with({}, :location => new_session_path(resource_name))
          else
            respond_with(resource)
          end
        else
          flash[:alert] = t('devise.invalid_captcha') if is_navigational_format?
          respond_with({}, :location => new_unlock_path(resource_name))
        end
      end
    end
  end
end
