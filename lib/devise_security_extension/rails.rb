module Devise
  module SecurityExtension
    class Engine < ::Rails::Engine

      ActiveSupport.on_load(:action_controller) do
        include Devise::SecurityExtension::Controllers::Helpers
      end

    end
  end
end
