Warden::Manager.after_authentication do |record, warden, options|
  warden.session(options[:scope])[:password_expired] = true if record.need_change_password?
end

Warden::Manager.before_logout do |record, warden, options|
  warden.session(options[:scope])[:password_expired] = false
end
