class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :reputation
      t.string :user_id
      t.text :profile_image
      t.string :display_name
      t.text :profile_link
      t.string :question_id

      t.timestamps null: false
    end
  end
end
