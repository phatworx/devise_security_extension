Warden::Manager.after_authentication do |record, warden, options|
  warden.session[:password_expired] = record.need_change_password?
end
