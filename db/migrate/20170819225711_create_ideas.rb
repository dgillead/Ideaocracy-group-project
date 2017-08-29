class CreateIdeas < ActiveRecord::Migration[5.1]
  def change
    create_table :ideas do |t|
      t.integer :user_id, null: false
      t.text :title, null: false
      t.text :summary, null: false
      t.text :tags
      t.integer :loves, array: true, default: []
      t.integer :loves_count, default: 0
      t.integer :collaborators, array: true, default: []
      t.timestamps
    end
  end
end
