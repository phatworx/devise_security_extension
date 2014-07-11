class User < ActiveRecord::Base
  devise :database_authenticatable, :password_archivable
end
