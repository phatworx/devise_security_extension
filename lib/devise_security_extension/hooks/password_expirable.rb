Warden::Manager.after_authentication do |record, warden, options|
  warden.session(options[:scope])[:password_expired] = record.need_change_password?
end
