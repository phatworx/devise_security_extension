require 'helper'

class TestPasswordArchivableOn < ActiveSupport::TestCase
  setup do
    Devise.password_archiving_count = 2
  end

  teardown do
    Devise.password_archiving_count = 1
  end

  test "should respect maximum attempts configuration" do
    User.deny_old_passwords = true
    user = User.new
    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_nothing_raised { user.save! }

    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'the option should be dynamic during runtime' do
    User.deny_old_passwords = true
    class ::User
      def archive_count
        1
      end
      def confirmed_password= password
        self.password = password
        self.password_confirmation = password
        self.save!
      end
    end

    user = User.new
    assert_nothing_raised { user.confirmed_password = 'password1' }
    assert_nothing_raised  { user.confirmed_password = 'password2' }

    assert_raises(ActiveRecord::RecordInvalid) { user.confirmed_password = 'password2' }

    assert_raises(ActiveRecord::RecordInvalid) { user.confirmed_password = 'password1' }
  end
end
class TestPasswordArchivableOff < ActiveSupport::TestCase
  setup do
    Devise.password_archiving_count = 2
  end

  teardown do
    Devise.password_archiving_count = 1
  end

  test "should respect maximum attempts configuration" do
    User.deny_old_passwords = false
    user = User.new
    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_nothing_raised { user.save! }

    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_nothing_raised { user.save! }
  end

  test 'the option should be dynamic during runtime' do
    class ::User
      def archive_count
        1
      end
      def confirmed_password= password
        self.password = password
        self.password_confirmation = password
        self.save!
      end
    end

    user = User.new
    assert_nothing_raised { user.confirmed_password = 'password1' }
    assert_nothing_raised  { user.confirmed_password = 'password2' }

    assert_nothing_raised { user.confirmed_password = 'password2' }

    assert_nothing_raised { user.confirmed_password = 'password1' }
  end
end

