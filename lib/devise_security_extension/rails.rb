module Devise
  module SecurityExtension
    class Engine < ::Rails::Engine

      # ActiveSupport.on_load(:action_controller) { include Devise::SecurityExtension::Something }
      # ActiveSupport.on_load(:action_view) { include Devise::SecurityExtension::Something }

      config.after_initialize do
        #
      end 

    end
  end
end
