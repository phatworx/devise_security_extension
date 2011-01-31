module Devise
  module SecurityExtension
    module Controllers

      module Helpers
        extend ActiveSupport::Concern

        included do
          before_filter :handle_password_change
        end

        module ClassMethods
        end

        module InstanceMethods
          private

          def handle_password_change
            Devise.mappings.keys.flatten.any? do |scope|
              if signed_in? scope
                if warden.session(scope)[:password_expired]
                  session["#{scope}_return_to"] = request.path if request.get?
                  redirect_for_password_change scope
                  break
                end
              end
            end
          end

          def redirect_for_password_change(scope)
            redirect_to change_password_required_path_for(scope), :alert => I18n.t('change_required', { :scope => 'devise.password_expired' })
          end

          def change_password_required_path_for(resource_or_scope = nil)
            scope       = Devise::Mapping.find_scope!(resource_or_scope)
            change_path = "#{scope}_password_expired_path"
            send(change_path)
          end

        end
      end
    end
  end

end
