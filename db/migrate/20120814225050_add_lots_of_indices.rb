class AddLotsOfIndices < ActiveRecord::Migration
	def change
		add_index :repos, :github_created_at
		add_index :repos, :github_updated_at
		add_index :repos, :description
		add_index :repos, :homepage
		add_index :repos, :language
		add_index :repos, :forks
		add_index :repos, :stars
		add_index :repos, :issues
		add_index :todo_files, :sha
  	end
end