module DeviseSecurityExtension
  module Generators # :nodoc:
    # Install Generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Install the devise security extension"

      def add_configs
        inject_into_file "config/initializers/devise.rb", "\n  # ==> Security Extension\n  # Configure security extension for devise\n\n" +
        "  # Should the password expire (e.g 3.months)\n" +
        "  # config.expire_password_after = false\n\n" +
        "  # Need 1 char of A-Z, a-z and 0-9\n" +
        "  # config.password_regex = /(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])/\n\n" +
        "  # How often save old passwords in archive\n" +
        "  # config.password_archiving_count = 5\n\n" +
        "  # Deny old password (true, false, count)\n" +
        "  # config.deny_old_passwords = true\n\n" +
        "  # enable email validation for :secure_validatable. (true, false, validation_options)\n" +
        "  # dependency: need an email validator like rails_email_validator\n" +
        "  # config.email_validation = true" +
        "\n", :before => /end[ |\n|]+\Z/
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.security_extension.en.yml"
        copy_file "../../../config/locales/de.yml", "config/locales/devise.security_extension.de.yml"
      end
    end
  end
end