module DeviseSecurityExtension::Patches
  # patch passwords controller for captcha
  module ControllerCaptcha
    extend ActiveSupport::Concern
    included do
    # here the patch

      alias_method :create_without_captcha_check, :create
      define_method :create do
        if valid_captcha? params[:captcha]
          create_without_captcha_check
        else
          build_resource
          clean_up_passwords(resource)
          flash[:alert] = I18n.translate('devise.invalid_captcha')
          render_with_scope :new
        end
      end
    end
  end
end
