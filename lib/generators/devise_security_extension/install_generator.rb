module DeviseSecurityExtension
  module Generators
    # Generator for Rails to create or append to a Devise initializer.
    class InstallGenerator < Rails::Generators::Base
      LOCALES = %w[ en de it ]

      source_root File.expand_path('../../templates', __FILE__)
      desc 'Install the devise security extension'

      def copy_initializer
        template('devise_security_extension.rb',
                 'config/initializers/devise_security_extension.rb',
        )
      end

      def copy_locales
        LOCALES.each do |locale|
          copy_file(
            "../../../config/locales/#{locale}.yml",
            "config/locales/devise.security_extension.#{locale}.yml",
          )
        end
      end
    end
  end
end
