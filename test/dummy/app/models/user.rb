class User < ActiveRecord::Base
  devise :database_authenticatable, :password_archivable,
         :paranoid_verification, :password_expirable
end
