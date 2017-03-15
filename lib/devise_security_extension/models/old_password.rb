require 'active_record'
class OldPassword < ActiveRecord::Base
  self.abstract_class = true
  belongs_to :password_archivable, :polymorphic => true
end
