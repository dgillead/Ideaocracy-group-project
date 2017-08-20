class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :idea_id
      t.integer :suggestion_id
      t.text :body, null: false
      t.timestamps
    end
  end
end
