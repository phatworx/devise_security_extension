module DeviseSecurityExtension
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Install the devise security extension"

      def add_configs
        inject_into_file "config/initializers/devise.rb", "\n\n  # ==> Security Extension\n  # Configure security extension for devise\n\n  # Should the password expire (e.g 3.months)\n  # config.expire_password_after = false\n\n", :before => /end[ |\n|]+\Z/
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.security_extension.en.yml"
        copy_file "../../../config/locales/de.yml", "config/locales/devise.security_extension.de.yml"
      end
    end
  end
end