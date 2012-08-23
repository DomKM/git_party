class AddIndicesOnShasAndTodos < ActiveRecord::Migration
  def change
  	add_index :shas, :repo_id
  	add_index :shas, :sha
  	add_index :shas, :type
  	add_index :todos, :sha_id
  end
end
