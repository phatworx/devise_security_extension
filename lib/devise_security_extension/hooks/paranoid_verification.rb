Warden::Manager.after_set_user do |record, warden, options|
  if record.respond_to?(:need_paranoid_verification?)
    warden.session(options[:scope])['paranoid_verify'] = record.need_paranoid_verification?
  end
end
