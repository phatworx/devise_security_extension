class OldPassword < ActiveRecord::Base
  belongs_to :password_archivable, :polymorphic => true
end
