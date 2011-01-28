Warden::Manager.after_set_user do |record, warden, options|
  Rails.logger.debug "after_login"
  if record.password_change_required?
    Rails.logger.debug "password change required"
  end
end