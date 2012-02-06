module DeviseSecurityExtension::Patches
  module SessionsControllerCaptcha
    extend ActiveSupport::Concern
    included do
      define_method :create do
        if valid_captcha? params[:captcha]
          resource = warden.authenticate!(auth_options)
          set_flash_message(:notice, :signed_in) if is_navigational_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => after_sign_in_path_for(resource)
        else
          flash[:alert] = t('devise.invalid_captcha') if is_navigational_format?
          respond_with({}, :location => new_session_path(resource_name))
        end
      end
    end
  end
end
