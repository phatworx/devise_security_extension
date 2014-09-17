Warden::Manager.after_authentication do |record, warden, options|
  if record.respond_to?(:password_needs_reset?)
    warden.session(options[:scope])['password_expired'] = record.password_needs_reset?
  end
end
