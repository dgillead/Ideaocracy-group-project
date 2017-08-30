class CreateSuggestions < ActiveRecord::Migration[5.1]
  def change
    create_table :suggestions do |t|
      t.integer :idea_id
      t.integer :user_id
      t.integer :votes, default: 1
      t.integer :up_votes, array: true, default: []
      t.integer :down_votes, array: true, default: []
      t.text :body, null: false
      t.timestamps
    end
  end
end
