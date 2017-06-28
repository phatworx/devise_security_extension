module DeviseSecurityExtension
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseSecurityExtension::Controllers::Helpers
    end

    rails_reloader_klass = if defined?(ActiveSupport::Reloader)
                             ActiveSupport::Reloader
                           else
                             ActionDispatch::Reloader
                           end

    rails_reloader_klass.to_prepare do
      DeviseSecurityExtension::Patches.apply
    end
  end
end
