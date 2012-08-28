class RenameIssuesToIssuesCountInRepos < ActiveRecord::Migration
  def change
  	rename_column :repos, :issues, :issues_count
  	remove_index :repos, :name => "index_repos_on_issues"
  	add_index :repos, :issues_count
  end
end
