class Devise::PasswordExpiredController < DeviseController
  skip_before_filter :handle_password_change
  prepend_before_filter :authenticate_scope!, :only => [:show, :update]

  def show
    if not resource.nil? and resource.password_needs_reset?
      respond_with(resource)
    else
      redirect_to :root
    end
  end

  def update
    if resource.update_password(resource_params)
      warden.session(scope)['password_expired'] = false
      set_flash_message :notice, :updated
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      set_flash_message :alert, :update_failed
      respond_with(resource, action: :show)
    end
  end

  private

  def resource_params
    params[resource_name]
  end

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
