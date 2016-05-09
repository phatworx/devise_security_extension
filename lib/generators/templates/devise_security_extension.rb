Devise.setup do |config|
  # ==> Security Extension
  # Configure security extension for devise

  # Should the password expire (e.g 3.months)
  # config.expire_password_after = false

  # Need 1 char of A-Z, a-z and 0-9
  # config.password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/

  # How many passwords to keep in archive
  # config.password_archiving_count = 5

  # Deny old password (true, false, count)
  # config.deny_old_passwords = true

  # enable email validation for :secure_validatable. (true, false, validation_options)
  # dependency: need an email validator like rails_email_validator
  # config.email_validation = true

  # captcha integration for recover form
  # config.captcha_for_recover = true

  # captcha integration for sign up form
  # config.captcha_for_sign_up = true

  # captcha integration for sign in form
  # config.captcha_for_sign_in = true

  # captcha integration for unlock form
  # config.captcha_for_unlock = true

  # captcha integration for confirmation form
  # config.captcha_for_confirmation = true

  # Time period for account expiry from last_activity_at
  # config.expire_after = 90.days
end
