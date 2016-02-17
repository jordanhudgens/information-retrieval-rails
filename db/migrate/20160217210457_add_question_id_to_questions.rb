class AddQuestionIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :question_id, :string
  end
end
