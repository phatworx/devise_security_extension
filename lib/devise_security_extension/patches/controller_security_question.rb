module DeviseSecurityExtension::Patches
  module ControllerSecurityQuestion
    extend ActiveSupport::Concern

    included do
      prepend_before_action :check_security_question, only: [:create]
    end

    private
    def check_security_question
      # only find via email, not login
      resource = resource_class.find_or_initialize_with_error_by(:email, params[resource_name][:email], :not_found)
      return if (resource.security_question_answer.present? && resource.security_question_answer == params[:security_question_answer])

      flash[:alert] = t('devise.invalid_security_question') if is_navigational_format?
      respond_with({}, location: url_for(action: :new))
    end
  end
end

