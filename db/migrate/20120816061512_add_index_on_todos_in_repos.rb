class AddIndexOnTodosInRepos < ActiveRecord::Migration
 def change
		add_index :repos, :todos
	end
end
