class AddTodosCountToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :todos_count, :integer
    add_index :repos, :todos_count
  end
end
