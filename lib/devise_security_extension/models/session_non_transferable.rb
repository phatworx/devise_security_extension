require 'devise_security_extension/hooks/session_non_transferable'

module Devise
  module Models
    # SessionNonTransferable works along SessionLimited and ensures,
    # session is bound to IP address and User Agent (browser).
    # This means that if someone capture users session id, and tries to
    # access the application from different IP or User agent, session
    # wont work.
    # Be aware that this solution is brittle and some users using broadband
    # that frequestly changes IP addresses (mobile broadband) may encounter
    # spontanious sign-outs
    module SessionNonTransferable
      extend ActiveSupport::Concern

      def update_current_user_agent!(user_agent)
        self.current_user_agent = user_agent

        save(:validate => false)
      end

    end
  end
end
