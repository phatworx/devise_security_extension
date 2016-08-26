require "test_helper"

class ViewsGeneratorTest < Rails::Generators::TestCase
  tests Devise::Generators::ViewsGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all views are properly created with no params" do
    run_generator
    assert_files
  end

  test "Assert all views are properly created with scope param" do
    run_generator %w(users)
    assert_files "users"

    run_generator %w(admins)
    assert_files "admins"
  end

  test "Assert only views within specified directories" do
    run_generator %w(-v paranoid_verification_code password_expired)
    assert_file "app/views/devise/paranoid_verification_code/show.html.erb"
    assert_file "app/views/devise/password_expired/show.html.erb"
  end

  test "Assert specified directories with scope" do
    run_generator %w(users -v password_expired)
    assert_file "app/views/users/password_expired/show.html.erb"
    assert_no_file "app/views/users/paranoid_verification_code/show.html.erb"
  end

  def assert_files(scope = nil)
    scope = "devise" if scope.nil?

    assert_file "app/views/#{scope}/paranoid_verification_code/show.html.erb"
    assert_file "app/views/#{scope}/password_expired/show.html.erb"
  end
end