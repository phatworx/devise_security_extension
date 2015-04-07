# This hook requires session_limitable 

# After each sign in, native Devise updates current_sign_in_ip and this hook
# updates unique_session_client.
# This is only triggered when the user is explicitly set (with set_user)
# and on authentication. Retrieving the user from session (:fetch) does
# not trigger it.
Warden::Manager.after_set_user :except => :fetch do |record, warden, options|
  if record.respond_to?(:update_unique_session_id!) && warden.authenticated?(options[:scope])
    begin
      # record.current_sign_in_ip is set by native Devise
      record.update_current_user_agent!(warden.request.user_agent)
    rescue
      throw :warden, :scope => scope, :message => :internal_error
    end
  end
end

# Each time a record is fetched from session we check if the request is from a same
# user agent (Browser) and from same IP addres as upon Sign-in.
# In combination with :session_limitable you prevent "transferable session_id"
Warden::Manager.after_set_user :only => :fetch do |record, warden, options|
  begin
    scope = options[:scope]
    env   = warden.request.env

    if warden.authenticated?(scope) && options[:store] != false

      if !env['devise.skip_session_non_transferable'] \
          && (record.current_user_agent != warden.request.user_agent \
              || record.current_sign_in_ip != warden.request.remote_ip )

        warden.logout(scope)
        throw :warden, :scope => scope, :message => :session_non_transferable
      end
    end
  rescue
    warden.logout(scope)
    throw :warden, :scope => scope, :message => :internal_error
  end
end
