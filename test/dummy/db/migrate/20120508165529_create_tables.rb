class CreateTables < MIGRATION_CLASS
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :facebook_token

      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.datetime :password_changed_at
      t.timestamps null: false
    end

    create_table :secure_users do |t|
      t.string :email
      t.string :encrypted_password, null: false, default: ''
      t.timestamps null: false
    end

    create_table :old_passwords do |t|
      t.string :encrypted_password

      t.references :password_archivable, polymorphic: true
    end
  end

  def self.down
    drop_table :users
    drop_table :secure_users
    drop_table :old_passwords
  end
end
