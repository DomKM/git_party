class RemoveTodosFromRepos < ActiveRecord::Migration
  def change
  	remove_column :repos, :todos
  end
end
