Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'
  config.secret_key = 'f08cf11a38906f531d2dfc9a2c2d671aa0021be806c21255d4'
  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]
end
