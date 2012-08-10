class AddIndexToTodoFileIdInTodoLines < ActiveRecord::Migration
  def change
    add_index :todo_lines, :todo_file_id
  end
end
