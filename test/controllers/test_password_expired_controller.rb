require 'test_helper'

class TestPasswordExpiredController < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @controller = Devise::PasswordExpiredController.new
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = User.create!(
      username: 'foo',
      password: 'password1',
      password_confirmation: 'password1'
    )
  end

  test 'redirects to root when resource is not present' do
    patch :update
    assert_redirected_to :root
    assert_nil flash[:notice]
  end

  test 'updates password and redirects to root when resource is present' do
    sign_in @user
    patch :update,
          user: {
            current_password: 'password1',
            password: 'newpassword',
            password_confirmation: 'newpassword'
          }
    assert_redirected_to :root
    assert_equal 'Your new password is saved.', flash[:notice]
    refute_equal @user.encrypted_password, @user.reload.encrypted_password
  end

  test 'renders show when password does not match password_confirmation' do
    sign_in @user
    patch :update,
          user: {
            current_password: 'password1',
            password: 'newpassword',
            password_confirmation: ''
          }
    assert_template :show
  end

  test 'renders show when new password is same as old password' do
    sign_in @user
    patch :update,
          user: {
            current_password: 'password1',
            password: 'password1',
            password_confirmation: 'password1'
          }
    assert_template :show
  end

  test 'renders show when current password is wrong' do
    sign_in @user
    patch :update,
          user: {
            current_password: 'invalidpassword',
            password: 'password1',
            password_confirmation: 'password1'
          }
    assert_template :show
  end

  test 'renders show when current password is blank' do
    sign_in @user
    patch :update,
          user: {
            current_password: '',
            password: 'password1',
            password_confirmation: 'password1'
          }
    assert_template :show
  end

  test 'renders show when only current password is filled in' do
    sign_in @user
    patch :update,
          user: {
            current_password: 'password1',
            password: '',
            password_confirmation: ''
          }
    assert_template :show
  end
end
