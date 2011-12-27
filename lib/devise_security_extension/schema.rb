module DeviseSecurityExtension
  # add schema helper for migrations
  module Schema
    # Add password_changed_at columns in the resource's database table.
    #
    # Examples
    #
    # # For a new resource migration:
    # create_table :the_resources do |t|
    #   t.password_expirable
    # ...
    # end
    #
    # # or if the resource's table already exists, define a migration and put this in:
    # change_table :the_resources do |t|
    #   t.datetime :password_changed_at
    # end
    #
    def password_expirable
      apply_devise_schema :password_changed_at, DateTime
    end

    # Add password_archivable columns
    #
    # Examples
    #
    # create_table :old_passwords do
    #   t.password_archivable
    # end
    # add_index :old_passwords, [:password_archivable_type, :password_archivable_id], :name => :index_password_archivable
    #
    def password_archivable
      apply_devise_schema :encrypted_password, String, :limit => 128, :null => false
      apply_devise_schema :password_salt, String
      apply_devise_schema :password_archivable_id, Integer, :null => false
      apply_devise_schema :password_archivable_type, String, :null => false
      apply_devise_schema :created_at, DateTime
    end

    # Add session_limitable columns in the resource's database table.
    #
    # Examples
    #
    # # For a new resource migration:
    # create_table :the_resources do |t|
    #   t.session_limitable
    # ...
    # end
    #
    # # or if the resource's table already exists, define a migration and put this in:
    # change_table :the_resources do |t|
    #   t.string :unique_session_id, :limit => 20
    # end
    #
    def session_limitable
      apply_devise_schema :unique_session_id, String, :limit => 20
    end
  end
end
