require 'test_helper'

class TestWithCaptcha < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  tests Captcha::SessionsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:captcha_user]
  end

  test 'When captcha is enabled, it is inserted correctly' do
    post :create, params: {
      captcha_user: {
        email: "wrong@email.com",
        password: "wrongpassword"
      }
    }

    assert_equal "The captcha input was invalid.", flash[:alert]
    assert_redirected_to new_captcha_user_session_path
  end

  test 'When captcha is valid, it runs as normal' do
    @controller.define_singleton_method(:verify_recaptcha) do
      true
    end

    post :create, params: {
      captcha: "ABCDE",
      captcha_user: {
        email: "wrong@email.com",
        password: "wrongpassword"
      }
    }

    assert_equal "Invalid Email or password.", flash[:alert]
  end
end

class TestWithoutCaptcha < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  tests Devise::SessionsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test 'When captcha is not enabled, it is not inserted' do
    post :create, params: { 
      user: {
        email: "wrong@email.com",
        password: "wrongpassword"
      }
    }

    assert_equal "Invalid Email or password.", flash[:alert]
  end
end
