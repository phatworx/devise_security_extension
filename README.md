# Devise Security Extension

[![Build Status](https://travis-ci.org/phatworx/devise_security_extension.svg?branch=master)](https://travis-ci.org/phatworx/devise_security_extension)

An enterprise security extension for [Devise](https://github.com/plataformatec/devise), trying to meet industrial standard security demands for web applications.

It is composed of 7 additional Devise modules:

* `:password_expirable` - passwords will expire after a configured time (and will need an update). You will most likely want to use `:password_expirable` together with the `:password_archivable` module to [prevent the current expired password being reused](https://github.com/phatworx/devise_security_extension/issues/175) immediately as the new password.
* `:secure_validatable` - better way to validate a model (email, stronger password validation). Don't use with Devise `:validatable` module!
* `:password_archivable` - save used passwords in an `old_passwords` table for history checks (don't be able to use a formerly used password)
* `:session_limitable` - ensures, that there is only one session usable per account at once
* `:expirable` - expires a user account after x days of inactivity (default 90 days)
* `:security_questionable` - as accessible substitution for captchas (security question with captcha fallback)
* `:paranoid_verification` - admin can generate verification code that user needs to fill in otherwise he wont be able to use the application.

Configuration and database schema for each module below.

## Additional features

* **captcha support** for `sign_up`, `sign_in`, `recover` and `unlock` (to make automated mass creation and brute forcing of accounts harder)

## Getting started

Devise Security Extension works with Devise on Rails 3.2 onwards. You can add it to your Gemfile after you successfully set up Devise (see [Devise documentation](https://github.com/plataformatec/devise)) with:

```ruby
gem 'devise_security_extension'
```

Run the bundle command to install it.

After you installed Devise Security Extension you need to run the generator:

```console
rails generate devise_security_extension:install
```

The generator adds optional configurations to `config/initializers/devise.rb`. Enable
the modules you wish to use in the initializer you are ready to add Devise Security Extension modules on top of Devise modules to any of your Devise models:

```ruby
devise :password_expirable, :secure_validatable, :password_archivable, :session_limitable, :expirable
```

for `:secure_validatable` you need to add

```ruby
gem 'rails_email_validator'
```

## Configuration

```ruby
Devise.setup do |config|
  # ==> Security Extension
  # Configure security extension for devise

  # Should the password expire (e.g 3.months)
  # config.expire_password_after = 3.months

  # Need 1 char of A-Z, a-z and 0-9
  # config.password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/

  # Number of old passwords in archive
  # config.password_archiving_count = 5

  # Deny old password (true, false, count)
  # config.deny_old_passwords = true

  # captcha integration for recover form
  # config.captcha_for_recover = true

  # captcha integration for sign up form
  # config.captcha_for_sign_up = true

  # captcha integration for sign in form
  # config.captcha_for_sign_in = true

  # captcha integration for unlock form
  # config.captcha_for_unlock = true

  # security_question integration for recover form
  # this automatically enables captchas (captcha_for_recover, as fallback)
  # config.security_question_for_recover = false

  # security_question integration for unlock form
  # this automatically enables captchas (captcha_for_unlock, as fallback)
  # config.security_question_for_unlock = false

  # security_question integration for confirmation form
  # this automatically enables captchas (captcha_for_confirmation, as fallback)
  # config.security_question_for_confirmation = false

  # ==> Configuration for :expirable
  # Time period for account expiry from last_activity_at
  # config.expire_after = 90.days
end
```

## Captcha-Support
The captcha support depends on [EasyCaptcha](https://github.com/phatworx/easy_captcha). See further documention there.

### Installation

1. Add EasyCaptcha to your `Gemfile` with
```ruby
gem 'easy_captcha'
```
2. Run the initializer
```ruby
rails generate easy_captcha:install
```
3. Enable captcha - see "Configuration" of Devise Security Extension above.
4. Add the captcha in the generated devise views for each controller you have activated
```erb
<p><%= captcha_tag %></p>
<p><%= text_field_tag :captcha %></p>
```

## Schema

### Password expirable
```ruby
create_table :the_resources do |t|
  # other devise fields

  t.datetime :password_changed_at
end
add_index :the_resources, :password_changed_at
```

### Password archivable
```ruby
create_table :old_passwords do |t|
  t.string :encrypted_password, :null => false
  t.string :password_archivable_type, :null => false
  t.integer :password_archivable_id, :null => false
  t.datetime :created_at
end
add_index :old_passwords, [:password_archivable_type, :password_archivable_id], :name => :index_password_archivable
```

### Session limitable
```ruby
create_table :the_resources do |t|
  # other devise fields

  t.string :unique_session_id, :limit => 20
end
```

### Expirable
```ruby
create_table :the_resources do |t|
  # other devise fields

  t.datetime :last_activity_at
  t.datetime :expired_at
end
add_index :the_resources, :last_activity_at
add_index :the_resources, :expired_at
```

### Paranoid verifiable
```ruby
create_table :the_resources do |t|
  # other devise fields

  t.string   :paranoid_verification_code
  t.integer  :paranoid_verification_attempt, default: 0
  t.datetime :paranoid_verified_at
end
add_index :the_resources, :paranoid_verification_code
add_index :the_resources, :paranoid_verified_at
```

[Documentation for Paranoid Verifiable module]( https://github.com/phatworx/devise_security_extension/wiki/Paranoid-Verification)

### Security questionable

```ruby
# app/models/security_question.rb
class SecurityQuestion < ActiveRecord::Base
  validates :locale, presence: true
  validates :name, presence: true, uniqueness: true
end
```

```ruby
create_table :security_questions do |t|
  t.string :locale, :null => false
  t.string :name, :null => false
end

SecurityQuestion.create! locale: :de, name: 'Wie lautet der Geburstname Ihrer Mutter?'
SecurityQuestion.create! locale: :de, name: 'Wo sind sie geboren?'
SecurityQuestion.create! locale: :de, name: 'Wie lautet der Name Ihres ersten Haustieres?'
SecurityQuestion.create! locale: :de, name: 'Was ist Ihr Lieblingsfilm?'
SecurityQuestion.create! locale: :de, name: 'Was ist Ihr Lieblingsbuch?'
SecurityQuestion.create! locale: :de, name: 'Was ist Ihr Lieblingstier?'
SecurityQuestion.create! locale: :de, name: 'Was ist Ihr Lieblings-Reiseland?'
```


```ruby
add_column :the_resources, :security_question_id, :integer
add_column :the_resources, :security_question_answer, :string
```

or

```ruby
create_table :the_resources do |t|
  # other devise fields

  t.integer :security_question_id
  t.string :security_question_answer
end
```

## Requirements

* Devise (https://github.com/plataformatec/devise)
* Rails 3.2 onwards (http://github.com/rails/rails)
* recommendations:
  * `autocomplete-off` (http://github.com/phatworx/autocomplete-off)
  * `easy_captcha` (http://github.com/phatworx/easy_captcha)
  * `rails_email_validator` (http://github.com/phatworx/rails_email_validator)


## Todo

* see the github issues (feature requests)

## History
* 0.1 expire passwords
* 0.2 strong password validation
* 0.3 password archivable with validation
* 0.4 captcha support for sign_up, sign_in, recover and unlock
* 0.5 session_limitable module
* 0.6 expirable module
* 0.7 security questionable module for recover and unlock
* 0.8 Support for Rails 4 (+ variety of patches)

## Maintainers

* Team Phatworx (https://github.com/phatworx)
* Alexander Dreher (https://github.com/alexdreher)
* Christoph Chilian (https://github.com/cc-web)
* Marco Scholl (https://github.com/traxanos)
* Thomas Powell (https://github.com/stringsn88keys)

## Contributing to devise_security_extension

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011-2015 Marco Scholl. See LICENSE.txt for further details.
