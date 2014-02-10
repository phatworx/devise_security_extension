class SecurityQuestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :locale, type: String
  field :name, type: String
end
