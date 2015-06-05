require 'test_helper'

class TestPasswordArchivable < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = User.create(email: 'hello@path.travel', password: '1234',
                        password_changed_at: 3.months.ago)
    sign_in(@user)
  end

  test 'should render new' do
    get :new
    assert_template :new
  end
end