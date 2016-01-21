module DeviseSecurityExtension::Patches
  module UnlocksControllerSecurityQuestion
    extend ActiveSupport::Concern
    included do
      define_method :create do
        # only find via email, not login
        resource = resource_class.find_or_initialize_with_error_by(:email, params[resource_name][:email], :not_found)

        if ((defined? verify_recaptcha) && (verify_recaptcha)) or ((defined? valid_captcha?) && (valid_captcha? params[:captcha]))
           (resource.security_question_answer.present? and resource.security_question_answer == params[:security_question_answer])
          self.resource = resource_class.send_unlock_instructions(params[resource_name])
          if successfully_sent?(resource)
            respond_with({}, :location => new_session_path(resource_name))
          else
            respond_with(resource)
          end
        else
          flash[:alert] = t('devise.invalid_security_question') if is_navigational_format?
          respond_with({}, :location => new_unlock_path(resource_name))
        end
      end
    end
  end
end
