module DeviseSecurityExtension::Patches
  module SessionsControllerCaptcha
    extend ActiveSupport::Concern
    included do
      define_method :create do |&block|
        if ((defined? verify_recaptcha) && (verify_recaptcha)) or ((defined? valid_captcha?) && (valid_captcha? params[:captcha]))
          self.resource = warden.authenticate!(auth_options)
          set_flash_message(:notice, :signed_in) if is_flashing_format?
          sign_in(resource_name, resource)
          block.call(resource) if block
          respond_with resource, :location => after_sign_in_path_for(resource)
        else
          flash[:alert] = t('devise.invalid_captcha') if is_flashing_format?
          respond_with({}, :location => new_session_path(resource_name))
        end
      end
    
      # for bad protected use in controller
      define_method :auth_options do
        { :scope => resource_name, :recall => "#{controller_path}#new" }
      end
    end
  end
end
