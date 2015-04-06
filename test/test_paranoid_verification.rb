require 'helper'

class TestPasswordVerifiable < ActiveSupport::TestCase

  test "need to paranoid verify if code present" do
    user = User.new
    user.generate_paranoid_code
    assert_equal(true, user.need_paranoid_verification?)
  end

  test "no need to paranoid verify if no code" do
    user = User.new
    assert_equal(false, user.need_paranoid_verification?)
  end

  test "generate code" do
    user = User.new
    user.generate_paranoid_code
    # default generator generates 5 char string
    assert_equal(user.paranoid_verification_code.class, String)
    assert_equal(user.paranoid_verification_code.length, 5)
  end

  test "when code match upon verify code, should mark record that it's no loger needed to verify" do
    user = User.new(paranoid_verification_code: 'abcde')

    assert_equal(true, user.need_paranoid_verification?)
    user.verify_code('abcde')
    assert_equal(false, user.need_paranoid_verification?)
  end

  test "when code match upon verify code, should no longer need verification" do
    user = User.new(paranoid_verification_code: 'abcde')

    assert_equal(true, user.need_paranoid_verification?)
    user.verify_code('abcde')
    assert_equal(false, user.need_paranoid_verification?)
  end

  test 'when code match upon verification code, should set when verification was accepted' do
    user = User.new(paranoid_verification_code: 'abcde')
    user.verify_code('abcde')
    assert_in_delta(4, Time.now.to_i, user.paranoid_verified_at.to_i)
  end

  test "when code not match upon verify code, should still need verification" do
    user = User.new(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_equal(true, user.need_paranoid_verification?)
  end

  test 'when code not match upon verification code, should not set paranoid_verified_at' do
    user = User.new(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_equal(nil, user.paranoid_verified_at)
  end
end
