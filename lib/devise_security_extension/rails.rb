module DeviseSecurityExtension
  class Engine < ::Rails::Engine # :nodoc:
    ActiveSupport.on_load(:action_controller) do
      include DeviseSecurityExtension::Controllers::Helpers
    end
  end
end
