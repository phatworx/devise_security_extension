# Updates the last_activity_at fields from the record. Only when the user is active 
# for authentication and authenticated.
# An expiry of the account is only checked on sign in OR on manually setting the 
# expired_at to the past (see Devise::Models::Expirable for this)
Warden::Manager.after_set_user do |record, warden, options|
  if record && record.respond_to?(:active_for_authentication?) && record.active_for_authentication? && 
      warden.authenticated?(options[:scope]) && record.respond_to?(:update_last_activity!)
    record.update_last_activity!
  end
end