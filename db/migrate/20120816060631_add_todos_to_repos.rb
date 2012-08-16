class AddTodosToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :todos, :integer
  end
end
