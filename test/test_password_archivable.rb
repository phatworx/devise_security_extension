require 'helper'

class TestPasswordArchivable < ActiveSupport::TestCase
  setup do
    Devise.password_archiving_count = 2
  end

  teardown do
    Devise.password_archiving_count = 1
  end

  test 'should respect maximum attempts configuration' do
    user = User.new
    user.password = 'password1'
    user.password_confirmation = 'password1'
    user.save!

    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end

  test 'the option should be dynamic during runtime' do
    class ::User
      def archive_count
        1
      end
    end

    user = User.new
    user.password = 'password1'
    user.password_confirmation = 'password1'
    user.save!

    user.password = 'password2'
    user.password_confirmation = 'password2'
    user.save!

    user.password = 'password2'
    user.password_confirmation = 'password2'
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }

    user.password = 'password1'
    user.password_confirmation = 'password1'
    assert_raises(ActiveRecord::RecordInvalid) { user.save! }
  end
end
