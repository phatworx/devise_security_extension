module DeviseSecurityExtension
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :handle_password_change
      end
      
      module ClassMethods
        # helper for captcha
        def init_recover_password_captcha
          include RecoverPasswordCaptcha
        end        
      end

      module RecoverPasswordCaptcha
        def new
          super
        end
      end

      # controller instance methods

        private

        # lookup if an password change needed
        def handle_password_change
          if not devise_controller? and not ignore_password_expire? and not request.format.nil? and request.format.html?
            Devise.mappings.keys.flatten.any? do |scope|
              if signed_in?(scope) and warden.session(scope)['password_expired']
                session["#{scope}_return_to"] = request.path if request.get?
                redirect_for_password_change scope
                return
              end
            end
          end
        end

        # redirect for password update with alert message
        def redirect_for_password_change(scope)
          redirect_to change_password_required_path_for(scope), :alert => I18n.t('change_required', {:scope => 'devise.password_expired'})
        end

        # path for change password
        def change_password_required_path_for(resource_or_scope = nil)
          scope       = Devise::Mapping.find_scope!(resource_or_scope)
          change_path = "#{scope}_password_expired_path"
          send(change_path)
        end
        
        protected
        
        # allow to overwrite for some special handlings
        def ignore_password_expire?
          false
        end


    end
  end

end
