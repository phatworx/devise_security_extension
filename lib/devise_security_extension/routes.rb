module ActionDispatch::Routing
  class Mapper

    protected

    # route for handle expired passwords
    def devise_password_expired(mapping, controllers)
      resource :password_expired, :only => [:show, :update], :path => mapping.path_names[:password_expired], :controller => controllers[:password_expired]
    end

    # route for handle paranoid verification
    def devise_verification_code(mapping, controllers)
      resource :paranoid_verification_code, :only => [:show, :update], :path => mapping.path_names[:verification_code], :controller => controllers[:paranoid_verification_code]
    end
  end
end

