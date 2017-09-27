require 'test_helper'

class TestParanoidVerification < ActiveSupport::TestCase
  test 'need to paranoid verify if code present' do
    user = User.new
    user.generate_paranoid_code
    assert_equal(true, user.need_paranoid_verification?)
  end

  test 'no need to paranoid verify if no code' do
    user = User.new
    assert_equal(false, user.need_paranoid_verification?)
  end

  test 'generate code' do
    user = User.new
    user.generate_paranoid_code
    assert_equal(0, user.paranoid_verification_attempt)
    user.verify_code('wrong')
    assert_equal(1, user.paranoid_verification_attempt)
    user.generate_paranoid_code
    assert_equal(0, user.paranoid_verification_attempt)
  end

  test "generate code must reset attempt counter" do
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

  test 'when code match upon verify code, should no longer need verification' do
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

  test 'when code not match upon verify code, should still need verification' do
    user = User.new(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_equal(true, user.need_paranoid_verification?)
  end

  test 'when code not match upon verification code, should not set paranoid_verified_at' do
    user = User.new(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_nil(user.paranoid_verified_at)
  end

  test 'when code not match upon verification code too many attempts should generate new code' do
    original_regenerate = Devise.paranoid_code_regenerate_after_attempt
    Devise.paranoid_code_regenerate_after_attempt = 2

    user = User.create(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_equal 'abcde', user.paranoid_verification_code
    user.verify_code('wrong-again')
    assert_not_equal 'abcde', user.paranoid_verification_code

    Devise.paranoid_code_regenerate_after_attempt = original_regenerate
  end

  test 'upon generating new code due to too many attempts reset attempt counter' do
    original_regenerate = Devise.paranoid_code_regenerate_after_attempt
    Devise.paranoid_code_regenerate_after_attempt = 3

    user = User.create(paranoid_verification_code: 'abcde')
    user.verify_code('wrong')
    assert_equal 1, user.paranoid_verification_attempt
    user.verify_code('wrong-again')
    assert_equal 2, user.paranoid_verification_attempt
    user.verify_code('WRONG!')
    assert_equal 0, user.paranoid_verification_attempt

    Devise.paranoid_code_regenerate_after_attempt = original_regenerate
  end


  test 'by default paranoid code regenerate should have 10 attempts' do
    user = User.new(paranoid_verification_code: 'abcde')
    assert_equal 10, user.paranoid_attempts_remaining
  end

  test 'paranoid_attempts_remaining should re-callculate how many attemps remains after each wrong attempt' do
    original_regenerate = Devise.paranoid_code_regenerate_after_attempt
    Devise.paranoid_code_regenerate_after_attempt = 2

    user = User.create(paranoid_verification_code: 'abcde')
    assert_equal 2, user.paranoid_attempts_remaining

    user.verify_code('WRONG!')
    assert_equal 1, user.paranoid_attempts_remaining

    Devise.paranoid_code_regenerate_after_attempt = original_regenerate
  end

  test 'when code not match upon verification code too many times, reset paranoid_attempts_remaining' do
    original_regenerate = Devise.paranoid_code_regenerate_after_attempt
    Devise.paranoid_code_regenerate_after_attempt = 1

    user = User.create(paranoid_verification_code: 'abcde')
    user.verify_code('wrong') # at this point code was regenerated
    assert_equal Devise.paranoid_code_regenerate_after_attempt, user.paranoid_attempts_remaining

    Devise.paranoid_code_regenerate_after_attempt = original_regenerate
  end
end
