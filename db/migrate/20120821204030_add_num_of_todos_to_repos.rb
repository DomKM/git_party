class AddNumOfTodosToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :num_of_todos, :integer
    add_index :repos, :num_of_todos
  end
end
