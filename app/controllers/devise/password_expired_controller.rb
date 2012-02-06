class Devise::PasswordExpiredController < DeviseController
  skip_before_filter :handle_password_change
  prepend_before_filter :authenticate_scope!, :only => [:show, :update]
  include Devise::Controllers::Helpers

  def show
    if not resource.nil? and resource.need_change_password?
      render 'devise/password_expired/show'
    else
      redirect_to :root
    end
  end

  def update
    if resource.update_with_password(params[resource_name])
      warden.session(scope)[:password_expired] = false
      set_flash_message :notice, :updated
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      clean_up_passwords(resource)
      render 'devise/password_expired/show'
    end
  end

  private

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
