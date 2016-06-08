class AddSecurityQuestionsFields < MIGRATION_CLASS
  def change
    add_column :users, :locked_at, :datetime
    add_column :users, :unlock_token, :string
    add_column :users, :security_question_id, :integer
    add_column :users, :security_question_answer, :string
  end
end
