class AddIndexToRepoIdInIssues < ActiveRecord::Migration
  def change
  	add_index :issues, :repo_id
  end
end
