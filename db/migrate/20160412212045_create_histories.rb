class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true, foreign_key: true
      t.string :query_title

      t.timestamps null: false
    end
  end
end
