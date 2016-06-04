module DeviseSecurityExtension
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_action :handle_password_change
        before_action :handle_paranoid_verification
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
          return if warden.nil?

          if not devise_controller? and not ignore_password_expire? and not request.format.nil? and request.format.html?
            Devise.mappings.keys.flatten.any? do |scope|
              if signed_in?(scope) and warden.session(scope)['password_expired']
                # re-check to avoid infinite loop if date changed after login attempt
                if send(:"current_#{scope}").try(:need_change_password?)
                  store_location_for(scope, request.original_fullpath) if request.get?
                  redirect_for_password_change scope
                  return
                else
                  warden.session(scope)[:password_expired] = false
                end
              end
            end
          end
        end

        # lookup if extra (paranoid) code verification is needed
        def handle_paranoid_verification
          return if warden.nil?

          if !devise_controller? && !request.format.nil? && request.format.html?
            Devise.mappings.keys.flatten.any? do |scope|
              if signed_in?(scope) && warden.session(scope)['paranoid_verify']
                store_location_for(scope, request.original_fullpath) if request.get?
                redirect_for_paranoid_verification scope
                return
              end
            end
          end
        end

        # redirect for password update with alert message
        def redirect_for_password_change(scope)
          redirect_to change_password_required_path_for(scope), :alert => I18n.t('change_required', {:scope => 'devise.password_expired'})
        end

        def redirect_for_paranoid_verification(scope)
          redirect_to paranoid_verification_code_path_for(scope), :alert => I18n.t('code_required', {:scope => 'devise.paranoid_verify'})
        end

        # path for change password
        def change_password_required_path_for(resource_or_scope = nil)
          scope       = Devise::Mapping.find_scope!(resource_or_scope)
          change_path = "#{scope}_password_expired_path"
          send(change_path)
        end

        def paranoid_verification_code_path_for(resource_or_scope = nil)
          scope       = Devise::Mapping.find_scope!(resource_or_scope)
          change_path = "#{scope}_paranoid_verification_code_path"
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
