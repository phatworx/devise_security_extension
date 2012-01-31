class OldPassword < ActiveRecord::Base
  belongs_to :password_archivable, :polymorphic => true

  attr_accessible :encrypted_password
end
