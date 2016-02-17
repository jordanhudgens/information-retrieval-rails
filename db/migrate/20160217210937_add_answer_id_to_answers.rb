class AddAnswerIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer_id, :string
  end
end
