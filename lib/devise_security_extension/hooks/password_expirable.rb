Warden::Manager.after_authentication do |record, warden, options|
  Rails.logger.debug record.inspect
  Rails.logger.debug record.need_change_password?
  warden.session[:password_expired] = record.need_change_password?
end
