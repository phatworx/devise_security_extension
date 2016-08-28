module DeviseSecurityExtension
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseSecurityExtension::Controllers::Helpers
    end

    if defined?(ActiveSupport::Reloader)
      ActiveSupport::Callbacks.to_prepare do
        DeviseSecurityExtension::Patches.apply
      end
    else
      ActionDispatch::Callbacks.to_prepare do
        DeviseSecurityExtension::Patches.apply
      end
    end
  end
end
