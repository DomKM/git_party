class DropTodoFilesAndTodoLines < ActiveRecord::Migration
  def change
  	drop_table :todo_files
  	drop_table :todo_lines
  end
end
