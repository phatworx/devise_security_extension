class Devise::PasswordExpiredController < DeviseController
  skip_before_filter :handle_password_change
  prepend_before_filter :authenticate_scope!, :only => [:show, :update]

  def show
    if not resource.nil? and resource.need_change_password?
      respond_with(resource)
    else
      redirect_to :root
    end
  end

  def update
    resource.extend(Devise::Models::DatabaseAuthenticatablePatch)
    if resource.update_with_password(resource_params)
      warden.session(scope)['password_expired'] = false
      set_flash_message :notice, :updated
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      clean_up_passwords(resource)
      respond_with(resource, action: :show)
    end
  end

  private
    def resource_params
      params.require(resource_name).permit(:current_password, :password, :password_confirmation)
    end

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
