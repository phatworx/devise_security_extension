class SecurityQuestion::UnlocksController < Devise::UnlocksController
  include DeviseSecurityExtension::Patches::ControllerSecurityQuestion
end
