module ActionDispatch::Routing
  class Mapper

    protected

    # route for handle expired passwords
    def devise_password_expired(mapping, controllers)
      resource :password_expired, :only => [:show, :update], :path => mapping.path_names[:password_expired], :controller => controllers[:password_expired]
    end

  end
end

