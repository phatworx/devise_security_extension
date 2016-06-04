require 'test_helper'
require 'rails_email_validator'

class TestSecureValidatable < ActiveSupport::TestCase
  class User < ActiveRecord::Base
    devise :database_authenticatable, :password_archivable,
           :paranoid_verification, :password_expirable, :secure_validatable
  end

  setup do
    Devise.password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
  end

  test 'email cannot be blank' do
    msg = "Email can't be blank"
    user = User.create password: 'passWord1', password_confirmation: 'passWord1'
    assert_equal(false, user.valid?)
    assert_equal([msg], user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test 'email must be valid' do
    msg = 'Email is invalid'
    user = User.create email: 'bob', password: 'passWord1', password_confirmation: 'passWord1'
    assert_equal(false, user.valid?)
    assert_equal([msg], user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test 'valid both email and password' do
    msgs = ['Email is invalid', 'Password must contain big, small letters and digits']
    user = User.create email: 'bob@foo.tv', password: 'password1', password_confirmation: 'password1'
    assert_equal(false, user.valid?)
    assert_equal(msgs, user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'password must have capital letter' do
    msgs = ['Email is invalid', 'Password must contain big, small letters and digits']
    user = User.create email: 'bob@example.org', password: 'password1', password_confirmation: 'password1'
    assert_equal(false, user.valid?)
    assert_equal(msgs, user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'password must have lowercase letter' do
    msg = 'Password must contain big, small letters and digits'
    user = User.create email: 'bob@microsoft.com', password: 'PASSWORD1', password_confirmation: 'PASSWORD1'
    assert_equal(false, user.valid?)
    assert_equal([msg], user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'password must have number' do
    msg = 'Password must contain big, small letters and digits'
    user = User.create email: 'bob@microsoft.com', password: 'PASSword', password_confirmation: 'PASSword'
    assert_equal(false, user.valid?)
    assert_equal([msg], user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'password must have minimum length' do
    msg = 'Password is too short (minimum is 6 characters)'
    user = User.create email: 'bob@microsoft.com', password: 'Pa3zZ', password_confirmation: 'Pa3zZ'
    assert_equal(false, user.valid?)
    assert_equal([msg], user.errors.full_messages)
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'duplicate email validation message is added only once' do
    options = {
      email: 'test@example.org',
      password: 'Test12345',
      password_confirmation: 'Test12345',
    }
    SecureUser.create!(options)
    user = SecureUser.new(options)
    refute user.valid?
    assert_equal ['Email has already been taken'], user.errors.full_messages
  end
end
