class AddFirstnameLastnameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :trello, :text
    add_column :users, :username, :text
    add_column :users, :loves, :integer, array: true, default: []
  end
end
