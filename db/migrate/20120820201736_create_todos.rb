class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :sha_id
      t.integer :line
      t.text :content

      t.timestamps
    end
  end
end
