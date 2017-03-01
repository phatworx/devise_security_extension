require 'test_helper'

class Devise::PasswordExpiredControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.create(username: 'hello', email: 'hello@path.travel',
                        password: '1234', password_changed_at: 3.months.ago)

    sign_in(@user)
  end

  test 'should render show' do
    get :show
    assert_includes @response.body, 'Renew your password'
  end

  test 'shold update password' do
    put :update, params: {
      user: {
        current_password: '1234',
        password: '12345',
        password_confirmation: '12345'
      }
    }
    assert_redirected_to root_path
  end
end
