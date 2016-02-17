class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :tags
      t.text :link
      t.string :creation_date
      t.text :title

      t.timestamps null: false
    end
  end
end
