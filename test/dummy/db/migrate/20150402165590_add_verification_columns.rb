class AddVerificationColumns < MIGRATION_CLASS
  def self.up
    add_column :users, :paranoid_verification_code, :string
    add_column :users, :paranoid_verified_at, :datetime
  end

  def self.down
    remove_column :users, :paranoid_verification_code
    remove_column :users, :paranoid_verified_at
  end
end
