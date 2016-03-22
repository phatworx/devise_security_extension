require 'test_helper'

class TestSecureValidatable < ActiveSupport::TestCase
  test 'duplicate email validation message is added only once' do
    options = {
      email: 'test@example.org',
      password: 'Test12345',
      password_confirmation: 'Test12345',
    }
    SecureUser.create!(options)
    user = SecureUser.new(options)
    assert ! user.valid?
    assert_equal ['Email has already been taken'], user.errors.full_messages
  end
end
