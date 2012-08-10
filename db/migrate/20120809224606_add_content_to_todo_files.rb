class AddContentToTodoFiles < ActiveRecord::Migration
  def change
    add_column :todo_files, :content, :text
  end
end
