class OldPassword < ActiveRecord::Base
  belongs_to :password_archivable, :polymorphic => true

  attr_accessor :encrypted_password, :password_salt
end
