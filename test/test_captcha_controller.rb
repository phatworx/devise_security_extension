require 'test_helper'

class TestCaptcha < ActiveSupport::TestCase
  test 'When captcha is not enabled it is not inserted' do
    skip "Assert the `check_captcha` method is in the various devise controllers"
  end

  test 'When captcha is enabled it is inserted correctly' do
    skip 
  end

  test 'When captcha methods are missing it returns runs as normal' do
    skip 
  end

  test 'When the captcha is invalid, it redirects to new action for each controller' do
    skip 
  end
end
