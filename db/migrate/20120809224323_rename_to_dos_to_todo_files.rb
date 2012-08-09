class RenameToDosToTodoFiles < ActiveRecord::Migration
  def change
    rename_table :to_dos, :todo_files
  end
end
