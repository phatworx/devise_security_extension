class AddVerificationAttemptColumn < MIGRATION_CLASS
  def self.up
    add_column :users, :paranoid_verification_attempt, :integer, default: 0
  end

  def self.down
    remove_column :users, :paranoid_verification_attempt
  end
end
