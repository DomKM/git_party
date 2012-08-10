class AddIndexToRepoIdColumnInTodoFiles < ActiveRecord::Migration
  def change
    add_index :todo_files, :repo_id, :uniqueness => true
  end
end
