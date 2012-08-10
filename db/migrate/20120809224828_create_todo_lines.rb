class CreateTodoLines < ActiveRecord::Migration
  def change
    create_table :todo_lines do |t|
      t.integer :todo_file_id
      t.integer :line_num

      t.timestamps
    end
  end
end
